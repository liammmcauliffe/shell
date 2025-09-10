#include "audioprovider.hpp"
#include "service.hpp"
#include <qaudiosource.h>
#include <qdebug.h>
#include <qiodevice.h>
#include <qmediadevices.h>
#include <qmutexlocker.h>
#include <qobject.h>
#include <qthread.h>
#include <qvector.h>
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstdlib>

namespace caelestia {

AudioCollector::AudioCollector(AudioProvider* provider, QObject* parent)
    : QObject(parent)
    , m_provider(provider)
    , m_sampleRate(provider->sampleRate())
    , m_chunkSize(provider->chunkSize())
    , m_chunk(m_chunkSize)
    , m_chunkOffset(0)
    , m_source(nullptr)
    , m_device(nullptr) {}

AudioCollector::~AudioCollector() {
    if (m_source) {
        m_source->stop();
    }
}

void AudioCollector::init() {
    QAudioFormat format;
    format.setSampleRate(m_sampleRate);
    format.setChannelCount(1);
    format.setSampleFormat(QAudioFormat::Int16);

    m_source = new QAudioSource(QMediaDevices::defaultAudioInput(), format, this);
    connect(m_source, &QAudioSource::stateChanged, this, &AudioCollector::handleStateChanged);
};

void AudioCollector::start() {
    if (!m_source) {
        return;
    }

    m_device = m_source->start();
    connect(m_device, &QIODevice::readyRead, this, &AudioCollector::loadChunk);
}

void AudioCollector::stop() {
    if (m_source) {
        m_source->stop();
        m_device = nullptr;
    }
}

void AudioCollector::loadChunk() {
    const QByteArray data = m_device->readAll();
    const int16_t* samples = reinterpret_cast<const int16_t*>(data.constData());
    const size_t count = static_cast<size_t>(data.size()) / sizeof(int16_t);

    size_t i = 0;
    while (i < count) {
        const int spaceLeft = m_chunkSize - m_chunkOffset;
        const auto toCopy = std::min<size_t>(static_cast<size_t>(spaceLeft), count - i);
        std::transform(samples + i, samples + i + toCopy, m_chunk.begin() + m_chunkOffset, [](int16_t sample) {
            return sample / 32768.0;
        });
        m_chunkOffset += toCopy;
        i += toCopy;
        if (m_chunkOffset == m_chunkSize) {
            if (std::any_of(m_chunk.constBegin(), m_chunk.constEnd(), [](double d) {
                    return std::abs(d) > 1e-6;
                })) {
                m_provider->loadChunk(m_chunk);
            }
            m_chunkOffset = 0;
        }
    }
}

void AudioCollector::handleStateChanged(QtAudio::State state) const {
    if (state == QtAudio::StoppedState && m_source->error() != QtAudio::NoError) {
        switch (m_source->error()) {
        case QtAudio::OpenError:
            qWarning() << "AudioCollector: failed to open audio device";
            break;
        case QtAudio::IOError:
            qWarning() << "AudioCollector: an error occurred during read/write of audio device";
            break;
        case QtAudio::UnderrunError:
            qWarning() << "AudioCollector: audio data is not being fed to audio device fast enough";
            break;
        case QtAudio::FatalError:
            qCritical() << "AudioCollector: fatal error in audio device";
            break;
        default:
            break;
        }
    }
}

AudioProcessor::AudioProcessor(AudioProvider* provider, QObject* parent)
    : QObject(parent)
    , m_sampleRate(provider->sampleRate())
    , m_chunkSize(provider->chunkSize())
    , m_provider(provider)
    , m_timer(nullptr) {}

AudioProcessor::~AudioProcessor() {
    if (m_timer) {
        m_timer->stop();
    }
}

void AudioProcessor::init() {
    m_timer = new QTimer(this);
    m_timer->setInterval(static_cast<int>(m_chunkSize * 1000.0 / m_sampleRate));
    connect(m_timer, &QTimer::timeout, this, &AudioProcessor::handleTimeout);
}

void AudioProcessor::start() {
    if (m_timer) {
        m_timer->start();
    }
}

void AudioProcessor::stop() {
    if (m_timer) {
        m_timer->stop();
    }
}

void AudioProcessor::handleTimeout() {
    const QVector<double> chunk = m_provider->nextChunk();
    if (!chunk.isEmpty()) {
        processChunk(chunk);
    }
}

AudioProvider::AudioProvider(int sampleRate, int chunkSize, QObject* parent)
    : Service(parent)
    , m_sampleRate(sampleRate)
    , m_chunkSize(chunkSize)
    , m_collector(new AudioCollector(this))
    , m_processor(nullptr)
    , m_collectorThread(new QThread(this))
    , m_processorThread(nullptr) {
    m_collector->moveToThread(m_collectorThread);
    connect(m_collectorThread, &QThread::started, m_collector, &AudioCollector::init);
    connect(m_collectorThread, &QThread::finished, m_collector, &AudioCollector::deleteLater);
    connect(m_collectorThread, &QThread::finished, m_collectorThread, &QThread::deleteLater);
    m_collectorThread->start();
}

AudioProvider::~AudioProvider() {
    m_collectorThread->quit();
    if (m_processorThread) {
        m_processorThread->quit();
        m_processorThread->wait();
    }
    m_collectorThread->wait();
}

int AudioProvider::sampleRate() const {
    return m_sampleRate;
}

int AudioProvider::chunkSize() const {
    return m_chunkSize;
}

QVector<double> AudioProvider::nextChunk() {
    QMutexLocker lock(&m_mutex);
    if (m_chunks.isEmpty()) {
        return {};
    }
    return m_chunks.dequeue();
}

void AudioProvider::loadChunk(const QVector<double>& chunk) {
    QMutexLocker lock(&m_mutex);
    m_chunks.enqueue(chunk);
}

void AudioProvider::init() {
    if (!m_processor) {
        qWarning() << "AudioProvider::init: attempted to init with no processor set";
        return;
    }

    m_processorThread = new QThread(this);
    m_processor->moveToThread(m_processorThread);
    connect(m_processorThread, &QThread::started, m_processor, &AudioProcessor::init);
    connect(m_processorThread, &QThread::finished, m_processor, &AudioProcessor::deleteLater);
    connect(m_processorThread, &QThread::finished, m_processorThread, &QThread::deleteLater);

    m_processorThread->start();
}

void AudioProvider::start() {
    QMetaObject::invokeMethod(m_collector, "start", Qt::QueuedConnection);
    if (m_processor) {
        QMetaObject::invokeMethod(m_processor, "start", Qt::QueuedConnection);
    }
}

void AudioProvider::stop() {
    QMetaObject::invokeMethod(m_collector, "stop", Qt::QueuedConnection);
    if (m_processor) {
        QMetaObject::invokeMethod(m_processor, "stop", Qt::QueuedConnection);
    }
}

} // namespace caelestia