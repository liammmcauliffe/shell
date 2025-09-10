#include "beattracker.hpp"

#include "audioprovider.hpp"
#include <aubio/aubio.h>

namespace caelestia {

BeatProcessor::BeatProcessor(AudioProvider* provider, QObject* parent)
    : AudioProcessor(provider, parent)
    , m_tempo(new_aubio_tempo("default", 1024, static_cast<uint_t>(m_chunkSize), static_cast<uint_t>(m_sampleRate)))
    , m_in(new_fvec(static_cast<uint_t>(m_chunkSize)))
    , m_out(new_fvec(2)) {};

BeatProcessor::~BeatProcessor() {
    del_aubio_tempo(m_tempo);
    del_fvec(m_in);
    del_fvec(m_out);
}

void BeatProcessor::processChunk(const QVector<double>& chunk) {
    std::transform(chunk.constBegin(), chunk.constEnd(), m_in->data, [](double d) {
        return static_cast<float>(d);
    });

    aubio_tempo_do(m_tempo, m_in, m_out);
    if (m_out->data[0] != 0.0f) {
        emit beat(aubio_tempo_get_bpm(m_tempo));
    }
}

BeatTracker::BeatTracker(int sampleRate, int chunkSize, QObject* parent)
    : AudioProvider(sampleRate, chunkSize, parent)
    , m_bpm(120) {
    m_processor = new BeatProcessor(this);
    init();

    connect(static_cast<BeatProcessor*>(m_processor), &BeatProcessor::beat, this, &BeatTracker::updateBpm);
}

smpl_t BeatTracker::bpm() const {
    return m_bpm;
}

void BeatTracker::updateBpm(smpl_t bpm) {
    if (!qFuzzyCompare(bpm + 1.0f, m_bpm + 1.0f)) {
        m_bpm = bpm;
        emit bpmChanged();
        emit beat(m_bpm);
    }
}

} // namespace caelestia