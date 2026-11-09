class ApplicationsMailer < ApplicationMailer
  def application_submitted(*args, **kwargs)
    @application, @recipient = resolve_application_payload(*args, **kwargs)
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @host

    mail(
      to: extract_email(@recipient),
      subject: "New application for #{@listing.title}",
      template_path: "applications_mailer",
      template_name: "application_submitted"
    )
  end

  def application_accepted(*args, **kwargs)
    @application, @recipient = resolve_application_payload(*args, **kwargs)
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @applicant

    mail(
      to: extract_email(@recipient),
      subject: "Application accepted for #{@listing.title}",
      template_path: "applications_mailer",
      template_name: "application_accepted"
    )
  end

  def application_rejected(*args, **kwargs)
    @application, @recipient = resolve_application_payload(*args, **kwargs)
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @applicant

    mail(
      to: extract_email(@recipient),
      subject: "Application rejected for #{@listing.title}",
      template_path: "applications_mailer",
      template_name: "application_rejected"
    )
  end

  def application_shortlisted(*args, **kwargs)
    @application, @recipient = resolve_application_payload(*args, **kwargs)
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @applicant

    mail(
      to: extract_email(@recipient),
      subject: "Application shortlisted for #{@listing.title}",
      template_path: "applications_mailer",
      template_name: "application_shortlisted"
    )
  end

  def application_withdrawn(*args, **kwargs)
    @application, @recipient = resolve_application_payload(*args, **kwargs)
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @host

    mail(
      to: extract_email(@recipient),
      subject: "Application withdrawn for #{@listing.title}",
      template_path: "applications_mailer",
      template_name: "application_withdrawn"
    )
  end

  def status_changed(*args, **kwargs)
    app, rec = resolve_application_payload(*args, **kwargs)
    case app&.status
    when "accepted" then application_accepted(*args, **kwargs)
    when "rejected" then application_rejected(*args, **kwargs)
    when "shortlisted" then application_shortlisted(*args, **kwargs)
    when "withdrawn" then application_withdrawn(*args, **kwargs)
    else
      @application = app
      @listing = app.listing
      @applicant = app.user
      @host = @listing.property.user
      @recipient = rec || @applicant

      mail(
        to: extract_email(@recipient),
        subject: "Application status updated for #{@listing.title}",
        template_path: "applications_mailer",
        template_name: "status_changed"
      )
    end
  end

  alias_method :submitted, :application_submitted
  alias_method :application_created, :application_submitted
  alias_method :accepted, :application_accepted
  alias_method :rejected, :application_rejected
  alias_method :shortlisted, :application_shortlisted
  alias_method :withdrawn, :application_withdrawn
  alias_method :application_status_changed, :status_changed
end
