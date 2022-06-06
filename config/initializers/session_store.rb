Rails.application.config.session_store :redis_store,
                                       servers: ["#{ENV['REDIS_URL']}/0/session"],
                                       expire_after: 90.minutes,
                                       key: '_cryptr_rails_regular_sample_session'
