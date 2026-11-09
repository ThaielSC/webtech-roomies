class ApplicationMailer < ActionMailer::Base
  default from: "notifications@example.com"
  layout "mailer"

  helper_method :recipient_name

  class << self
    def method_missing(method_name, *args, **kwargs, &block)
      if self == ApplicationMailer
        if ApplicationsMailer.respond_to?(method_name)
          return ApplicationsMailer.public_send(method_name, *args, **kwargs, &block)
        elsif VisitsMailer.respond_to?(method_name)
          return VisitsMailer.public_send(method_name, *args, **kwargs, &block)
        end
      end
      super
    end

    def respond_to_missing?(method_name, include_private = false)
      if self == ApplicationMailer
        return true if ApplicationsMailer.respond_to?(method_name, include_private) ||
                       VisitsMailer.respond_to?(method_name, include_private)
      end
      super
    end
  end

  def recipient_name(fallback = "there")
    if @recipient.respond_to?(:first_name) && @recipient.first_name.present?
      @recipient.first_name
    elsif @applicant.respond_to?(:first_name) && @applicant.first_name.present?
      @applicant.first_name
    elsif @host.respond_to?(:first_name) && @host.first_name.present?
      @host.first_name
    else
      fallback
    end
  end

  private

  def resolve_application_payload(*args, **kwargs)
    hash = args.extract_options!.merge(kwargs)
    app = hash[:application] || hash[:record] || hash[:app]
    rec = hash[:recipient] || hash[:user] || hash[:to] || hash[:host] || hash[:applicant]

    args.each do |arg|
      case arg
      when Application
        app ||= arg
      when User
        rec ||= arg
      when Integer
        if app.nil?
          app = Application.find_by(id: arg)
        else
          rec = User.find_by(id: arg)
        end
      when String
        if app.nil? && arg.match?(/\A\d+\z/)
          app = Application.find_by(id: arg.to_i)
        else
          rec ||= arg
        end
      end
    end

    if app.is_a?(Integer) || (app.is_a?(String) && app.match?(/\A\d+\z/))
      app = Application.find_by(id: app.to_i)
    end

    if rec.is_a?(Integer) || (rec.is_a?(String) && rec.match?(/\A\d+\z/))
      rec = User.find_by(id: rec.to_i)
    end

    [ app, rec ]
  end

  def resolve_visit_payload(*args, **kwargs)
    hash = args.extract_options!.merge(kwargs)
    vis = hash[:visit] || hash[:record]
    rec = hash[:recipient] || hash[:user] || hash[:to] || hash[:host] || hash[:applicant]

    args.each do |arg|
      case arg
      when Visit
        vis ||= arg
      when User
        rec ||= arg
      when Integer
        if vis.nil?
          vis = Visit.find_by(id: arg)
        else
          rec = User.find_by(id: arg)
        end
      when String
        if vis.nil? && arg.match?(/\A\d+\z/)
          vis = Visit.find_by(id: arg.to_i)
        else
          rec ||= arg
        end
      end
    end

    if vis.is_a?(Integer) || (vis.is_a?(String) && vis.match?(/\A\d+\z/))
      vis = Visit.find_by(id: vis.to_i)
    end

    if rec.is_a?(Integer) || (rec.is_a?(String) && rec.match?(/\A\d+\z/))
      rec = User.find_by(id: rec.to_i)
    end

    [ vis, rec ]
  end

  def extract_email(recipient)
    if recipient.respond_to?(:email_address)
      recipient.email_address
    elsif recipient.is_a?(String)
      recipient
    end
  end
end
