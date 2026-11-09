module Api
  module V1
    class ListingsController < BaseController
      include Rails.application.routes.url_helpers

      before_action :set_listing, only: [ :show ]

      def index
        listings = Listing.published.includes(
          :neighborhood,
          property: [ :amenities, :property_amenities ],
          photos_attachments: :blob
        )

        if params[:query].present?
          query = "%#{params[:query].to_s.strip}%"
          listings = listings.where("listings.title ILIKE ?", query)
        end

        if params[:neighborhood_id].present?
          listings = listings.joins(:property).where(properties: { neighborhood_id: params[:neighborhood_id] })
        end

        if params[:min_price].present?
          min_price = Float(params[:min_price]) rescue nil
          return render_invalid_param("min_price must be a positive number") if min_price.nil? || min_price < 0

          listings = listings.where("monthly_rent >= ?", min_price)
        end

        if params[:max_price].present?
          max_price = Float(params[:max_price]) rescue nil
          return render_invalid_param("max_price must be a positive number") if max_price.nil? || max_price < 0

          listings = listings.where("monthly_rent <= ?", max_price)
        end

        if params[:min_price].present? && params[:max_price].present?
          if min_price && max_price && min_price > max_price
            return render_invalid_param("min_price cannot be greater than max_price")
          end
        end

        if params[:is_furnished].present?
          furnished = parse_boolean(params[:is_furnished])
          return render_invalid_param("is_furnished must be true or false") if furnished.nil?

          listings = listings.where(is_furnished: furnished)
        end

        if params[:has_private_bathroom].present?
          private_bath = parse_boolean(params[:has_private_bathroom])
          return render_invalid_param("has_private_bathroom must be true or false") if private_bath.nil?

          listings = listings.where(has_private_bathroom: private_bath)
        end

        if params[:property_type].present?
          type = params[:property_type].to_s.downcase
          valid_types = Property.property_types.keys
          unless valid_types.include?(type)
            return render_invalid_param("property_type must be one of: #{valid_types.join(', ')}")
          end

          listings = listings.joins(:property).where(properties: { property_type: type })
        end

        render json: {
          data: listings.map { |listing| serialize_listing(listing) },
          meta: {
            total: listings.size
          }
        }, status: :ok
      end

      def show
        render json: {
          data: serialize_listing(@listing, full: true)
        }, status: :ok
      end

      private

      def set_listing
        @listing = Listing.published.includes(
          :neighborhood,
          property: [ :amenities, :property_amenities ],
          photos_attachments: :blob
        ).find(params[:id])
      end

      def serialize_listing(listing, full: false)
        data = {
          id: listing.id,
          title: listing.title,
          monthly_rent: listing.monthly_rent.to_f,
          deposit: listing.deposit.to_f,
          available_date: listing.available_date,
          minimum_stay_months: listing.minimum_stay_months,
          is_furnished: listing.is_furnished,
          has_private_bathroom: listing.has_private_bathroom,
          status: listing.status,
          neighborhood: {
            id: listing.neighborhood&.id,
            name: listing.neighborhood&.name
          },
          property: {
            id: listing.property.id,
            address: listing.property.address,
            property_type: listing.property.property_type,
            bedrooms_count: listing.property.bedrooms_count,
            bathrooms_count: listing.property.bathrooms_count,
            amenities: listing.property.amenities.map { |a| { id: a.id, name: a.name } }
          },
          photos: listing.photos.map { |photo| rails_blob_path(photo, only_path: true) }
        }

        if full
          data[:description] = listing.description&.to_plain_text
          data[:house_rules] = listing.house_rules&.to_plain_text
        end

        data
      end

      def parse_boolean(value)
        return true if [ true, 1, "true", "1", "t", "yes" ].include?(value)
        return false if [ false, 0, "false", "0", "f", "no" ].include?(value)

        nil
      end

      def render_invalid_param(message)
        render json: { error: "Bad Request", message: message }, status: :bad_request
      end
    end
  end
end
