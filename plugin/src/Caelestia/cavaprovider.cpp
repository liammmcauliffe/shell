#include "cavaprovider.hpp"
#include "audioprovider.hpp"
#include <qdebug.h>
#include <qobject.h>
#include <cava/cavacore.h>
#include <cmath>
#include <cstddef>

namespace caelestia {

CavaProcessor::CavaProcessor(AudioProvider* provider, QObject* parent)
    : AudioProcessor(provider, parent)
    , m_plan(nullptr)
    , m_in(new double[static_cast<size_t>(m_chunkSize)])
    , m_out(nullptr)
    , m_bars(0) {};

CavaProcessor::~CavaProcessor() {
    cleanup();
    delete[] m_in;
}

void CavaProcessor::setBars(int bars) {
    if (bars < 0) {
        qWarning() << "CavaProcessor::setBars: bars must be greater than 0. Setting to 0.";
        bars = 0;
    }
    if (m_bars != bars) {
        m_bars = bars;
        reload();
    }
}

void CavaProcessor::reload() {
    cleanup();
    initCava();
}

void CavaProcessor::cleanup() {
    if (!m_plan) {
        return;
    }
    cava_destroy(m_plan);
    m_plan = nullptr;
    if (m_out) {
        delete[] m_out;
        m_out = nullptr;
    }
}

void CavaProcessor::initCava() {
    if (m_plan || m_bars == 0) {
        return;
    }
    m_plan = cava_init(m_bars, static_cast<unsigned int>(m_sampleRate), 1, 1, 0.85, 50, 10000);
    if (m_plan->status == -1) {
        qWarning() << "CavaProcessor::initCava: failed to initialise cava plan";
        cleanup();
        return;
    }
    m_out = new double[static_cast<size_t>(m_bars)];
}

void CavaProcessor::processChunk(const QVector<double>& chunk) {
    if (!m_plan || m_bars == 0) {
        return;
    }
    std::copy(chunk.constBegin(), chunk.constEnd(), m_in);
    // Process in data via cava
    cava_execute(m_in, m_chunkSize, m_out, m_plan);
    // Apply monstercat filter
    for (int i = 0; i < m_bars; i++) {
        for (int j = i - 1; j >= 0; j--) {
            m_out[j] = std::max(m_out[i] / std::pow(1.5, i - j), m_out[j]);
        }
        for (int j = i + 1; j < m_bars; j++) {
            m_out[j] = std::max(m_out[i] / std::pow(1.5, j - i), m_out[j]);
        }
    }
    // Update values
    QVector<double> values(m_bars);
    std::copy(m_out, m_out + m_bars, values.begin());
    if (values != m_values) {
        m_values = std::move(values);
        emit valuesChanged(m_values);
    }
}

CavaProvider::CavaProvider(int sampleRate, int chunkSize, QObject* parent)
    : AudioProvider(sampleRate, chunkSize, parent)
    , m_bars(0)
    , m_values(m_bars) {
    m_processor = new CavaProcessor(this);
    init();
    connect(static_cast<CavaProcessor*>(m_processor), &CavaProcessor::valuesChanged, this, &CavaProvider::updateValues);
}

int CavaProvider::bars() const {
    return m_bars;
}

void CavaProvider::setBars(int bars) {
    if (bars < 0) {
        qWarning() << "CavaProvider::setBars: bars must be greater than 0. Setting to 0.";
        bars = 0;
    }
    if (m_bars == bars) {
        return;
    }

    m_values.resize(bars);
    m_bars = bars;
    emit barsChanged();
    emit valuesChanged();

    QMetaObject::invokeMethod(m_processor, "setBars", Qt::QueuedConnection, Q_ARG(int, bars));
}

QVector<double> CavaProvider::values() const {
    return m_values;
}

void CavaProvider::updateValues(QVector<double> values) {
    if (values != m_values) {
        m_values = values;
        emit valuesChanged();
    }
}

} // namespace caelestia