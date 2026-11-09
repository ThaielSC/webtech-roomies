class VisitsMailer < ApplicationMailer
  def visit_proposed(*args, **kwargs)
    @visit, @recipient = resolve_visit_payload(*args, **kwargs)
    @application = @visit.application
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @applicant

    mail(
      to: extract_email(@recipient),
      subject: "Visit proposed for #{@listing.title}",
      template_path: "visits_mailer",
      template_name: "visit_proposed"
    )
  end

  def visit_confirmed(*args, **kwargs)
    @visit, @recipient = resolve_visit_payload(*args, **kwargs)
    @application = @visit.application
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @applicant

    mail(
      to: extract_email(@recipient),
      subject: "Visit confirmed for #{@listing.title}",
      template_path: "visits_mailer",
      template_name: "visit_confirmed"
    )
  end

  def visit_cancelled(*args, **kwargs)
    @visit, @recipient = resolve_visit_payload(*args, **kwargs)
    @application = @visit.application
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @applicant

    mail(
      to: extract_email(@recipient),
      subject: "Visit cancelled for #{@listing.title}",
      template_path: "visits_mailer",
      template_name: "visit_cancelled"
    )
  end

  def visit_rescheduled(*args, **kwargs)
    @visit, @recipient = resolve_visit_payload(*args, **kwargs)
    @application = @visit.application
    @listing = @application.listing
    @applicant = @application.user
    @host = @listing.property.user
    @recipient ||= @applicant

    mail(
      to: extract_email(@recipient),
      subject: "Visit rescheduled for #{@listing.title}",
      template_path: "visits_mailer",
      template_name: "visit_rescheduled"
    )
  end

  alias_method :proposed, :visit_proposed
  alias_method :confirmed, :visit_confirmed
  alias_method :cancelled, :visit_cancelled
  alias_method :visit_canceled, :visit_cancelled
  alias_method :canceled, :visit_cancelled
  alias_method :rescheduled, :visit_rescheduled
end
