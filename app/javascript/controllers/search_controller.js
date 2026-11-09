import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "query",
    "neighborhood",
    "propertyType",
    "minPrice",
    "maxPrice",
    "isFurnished",
    "hasPrivateBathroom",
    "results",
    "loading",
    "empty",
    "error",
    "errorMessage",
    "count"
  ]

  connect() {
    this.timeout = null
    this.fetchListings()
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }

  onInput() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.fetchListings()
    }, 300)
  }

  onChange() {
    this.fetchListings()
  }

  reset(event) {
    if (event) event.preventDefault()
    if (this.hasQueryTarget) this.queryTarget.value = ""
    if (this.hasNeighborhoodTarget) this.neighborhoodTarget.value = ""
    if (this.hasPropertyTypeTarget) this.propertyTypeTarget.value = ""
    if (this.hasMinPriceTarget) this.minPriceTarget.value = ""
    if (this.hasMaxPriceTarget) this.maxPriceTarget.value = ""
    if (this.hasIsFurnishedTarget) this.isFurnishedTarget.checked = false
    if (this.hasHasPrivateBathroomTarget) this.hasPrivateBathroomTarget.checked = false
    this.fetchListings()
  }

  async fetchListings() {
    this.showLoading()

    const params = new URLSearchParams()

    if (this.hasQueryTarget && this.queryTarget.value.trim() !== "") {
      params.append("query", this.queryTarget.value.trim())
    }
    if (this.hasNeighborhoodTarget && this.neighborhoodTarget.value !== "") {
      params.append("neighborhood_id", this.neighborhoodTarget.value)
    }
    if (this.hasPropertyTypeTarget && this.propertyTypeTarget.value !== "") {
      params.append("property_type", this.propertyTypeTarget.value)
    }
    if (this.hasMinPriceTarget && this.minPriceTarget.value !== "") {
      params.append("min_price", this.minPriceTarget.value)
    }
    if (this.hasMaxPriceTarget && this.maxPriceTarget.value !== "") {
      params.append("max_price", this.maxPriceTarget.value)
    }
    if (this.hasIsFurnishedTarget && this.isFurnishedTarget.checked) {
      params.append("is_furnished", "true")
    }
    if (this.hasHasPrivateBathroomTarget && this.hasPrivateBathroomTarget.checked) {
      params.append("has_private_bathroom", "true")
    }

    const url = `/api/v1/listings?${params.toString()}`

    try {
      const response = await fetch(url, {
        headers: {
          "Accept": "application/json"
        }
      })

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}))
        const message = errorData.message || `Request failed with status ${response.status}`
        this.showError(message)
        return
      }

      const payload = await response.json()
      const listings = payload.data || []
      const total = payload.meta ? payload.meta.total : listings.length

      this.renderListings(listings, total)
    } catch (err) {
      this.showError("Unable to connect to the listings service. Please check your network connection.")
    }
  }

  showLoading() {
    if (this.hasLoadingTarget) this.loadingTarget.classList.remove("d-none")
    if (this.hasEmptyTarget) this.emptyTarget.classList.add("d-none")
    if (this.hasErrorTarget) this.errorTarget.classList.add("d-none")
  }

  showError(message) {
    if (this.hasLoadingTarget) this.loadingTarget.classList.add("d-none")
    if (this.hasEmptyTarget) this.emptyTarget.classList.add("d-none")
    if (this.hasResultsTarget) this.resultsTarget.innerHTML = ""
    if (this.hasCountTarget) this.countTarget.textContent = "0"
    if (this.hasErrorMessageTarget) this.errorMessageTarget.textContent = message
    if (this.hasErrorTarget) this.errorTarget.classList.remove("d-none")
  }

  renderListings(listings, total) {
    if (this.hasLoadingTarget) this.loadingTarget.classList.add("d-none")
    if (this.hasErrorTarget) this.errorTarget.classList.add("d-none")

    if (this.hasCountTarget) {
      this.countTarget.textContent = total
    }

    if (listings.length === 0) {
      if (this.hasResultsTarget) this.resultsTarget.innerHTML = ""
      if (this.hasEmptyTarget) this.emptyTarget.classList.remove("d-none")
      return
    }

    if (this.hasEmptyTarget) this.emptyTarget.classList.add("d-none")

    const cardsHtml = listings.map(listing => this.buildCardHtml(listing)).join("")
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = cardsHtml
    }
  }

  buildCardHtml(listing) {
    const photoHtml = (listing.photos && listing.photos.length > 0)
      ? `<img src="${listing.photos[0]}" class="card-img-top" style="height: 200px; object-fit: cover;" alt="${this.escapeHtml(listing.title)}">`
      : `<div class="bg-light d-flex align-items-center justify-content-center" style="height: 200px;"><span class="text-muted">No photograph available</span></div>`

    const furnishedBadge = listing.is_furnished
      ? `<span class="badge text-bg-info me-1">Furnished</span>`
      : ""

    const bathBadge = listing.has_private_bathroom
      ? `<span class="badge text-bg-secondary me-1">Private Bathroom</span>`
      : ""

    const neighborhoodName = listing.neighborhood ? this.escapeHtml(listing.neighborhood.name) : "N/A"
    const address = listing.property ? this.escapeHtml(listing.property.address) : ""
    const propertyType = listing.property && listing.property.property_type
      ? listing.property.property_type.charAt(0).toUpperCase() + listing.property.property_type.slice(1)
      : ""

    return `
      <div class="col-md-6 col-lg-4">
        <article class="card h-100 shadow-sm">
          ${photoHtml}
          <div class="card-body d-flex flex-column">
            <h2 class="card-title h5 mb-3">${this.escapeHtml(listing.title)}</h2>

            <p class="card-text mb-1">
              <strong>Neighborhood:</strong> ${neighborhoodName}
            </p>

            <p class="card-text mb-1">
              <strong>Rent:</strong> UF ${Number(listing.monthly_rent).toFixed(2)} / month
            </p>

            <p class="card-text mb-1">
              <strong>Available:</strong> ${this.formatDate(listing.available_date)}
            </p>

            <p class="card-text mb-1">
              <strong>Property:</strong> ${address} (${propertyType})
            </p>

            <div class="my-2">
              ${furnishedBadge}
              ${bathBadge}
            </div>

            <div class="d-flex flex-wrap gap-2 mt-auto pt-3">
              <a href="/listings/${listing.id}" class="btn btn-primary btn-sm">View listing</a>
            </div>
          </div>
        </article>
      </div>
    `
  }

  formatDate(dateStr) {
    if (!dateStr) return ""
    try {
      const parts = dateStr.split("-")
      if (parts.length === 3) {
        const date = new Date(parts[0], parts[1] - 1, parts[2])
        return date.toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" })
      }
      return dateStr
    } catch (e) {
      return dateStr
    }
  }

  escapeHtml(str) {
    if (!str) return ""
    return str
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;")
  }
}
