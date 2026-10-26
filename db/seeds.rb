# db/seeds.rb
# frozen_string_literal: true

puts "=== Limpiando base de datos ==="
# Limpieza en orden inverso de dependencias para evitar errores de claves foráneas
Report.destroy_all
SavedListing.destroy_all
Review.destroy_all
Visit.destroy_all
Application.destroy_all
Listing.destroy_all
PropertyAmenity.destroy_all
Property.destroy_all
Amenity.destroy_all
Neighborhood.destroy_all
User.destroy_all

puts "=== Creando Barrios de Santiago ==="
neighborhood_names = [
  "Providencia",
  "Las Condes",
  "Ñuñoa",
  "Santiago Centro",
  "Barrio Lastarria",
  "Barrio Bellavista",
  "Barrio Italia",
  "Vitacura",
  "San Miguel",
  "La Florida",
  "Macul",
  "Quinta Normal"
]

neighborhoods = neighborhood_names.each_with_object({}) do |name, hash|
  hash[name] = Neighborhood.create!(name: name)
end

puts "=== Creando Comodidades (Amenities) ==="
amenity_names = [
  "Wi-Fi de alta velocidad (Fibra)",
  "Lavadora y Secadora",
  "Calefacción central",
  "Admite mascotas",
  "Estacionamiento privado",
  "Piscina",
  "Quincho para asados",
  "Gimnasio equipado",
  "Conserjería 24/7",
  "Balcón / Terraza privada",
  "Cocina totalmente equipada",
  "Aire acondicionado",
  "Ascensor",
  "Bicicletero seguro"
]

amenities = amenity_names.each_with_object({}) do |name, hash|
  hash[name] = Amenity.create!(name: name)
end

puts "=== Creando Usuarios (Anfitriones, Postulantes y Moderador) ==="
# Contraseña común para facilitar pruebas manuales
default_password = "password123"

# 1. Moderador del sistema
admin = User.create!(
  first_name: "Administrador",
  last_name: "Roomies",
  email_address: "moderador@roomies.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 1111 2222",
  is_moderator: true
)

# 2. Anfitriones (Hosts)
camila = User.create!(
  first_name: "Camila",
  last_name: "Soto",
  email_address: "camila.soto@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 8765 4321",
  is_moderator: false
)

felipe = User.create!(
  first_name: "Felipe",
  last_name: "González",
  email_address: "felipe.gonzalez@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 7654 3210",
  is_moderator: false
)

valentina = User.create!(
  first_name: "Valentina",
  last_name: "Morales",
  email_address: "valentina.morales@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 6543 2109",
  is_moderator: false
)

matias = User.create!(
  first_name: "Matías",
  last_name: "Concha",
  email_address: "matias.concha@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 5432 1098",
  is_moderator: false
)

ignacia = User.create!(
  first_name: "Ignacia",
  last_name: "Silva",
  email_address: "ignacia.silva@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 4321 0987",
  is_moderator: false
)

# 3. Buscadores de habitación (Seekers)
diego = User.create!(
  first_name: "Diego",
  last_name: "Rojas",
  email_address: "diego.rojas@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 3210 9876",
  is_moderator: false
)

catalina = User.create!(
  first_name: "Catalina",
  last_name: "Fuentes",
  email_address: "catalina.fuentes@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 2109 8765",
  is_moderator: false
)

lucas = User.create!(
  first_name: "Lucas",
  last_name: "Benítez",
  email_address: "lucas.benitez@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 1098 7654",
  is_moderator: false
)

sofia = User.create!(
  first_name: "Sofía",
  last_name: "Valenzuela",
  email_address: "sofia.valenzuela@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 9988 7766",
  is_moderator: false
)

martin = User.create!(
  first_name: "Martín",
  last_name: "Carrasco",
  email_address: "martin.carrasco@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 8877 6655",
  is_moderator: false
)

florencia = User.create!(
  first_name: "Florencia",
  last_name: "Herrera",
  email_address: "florencia.herrera@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 7766 5544",
  is_moderator: false
)

tomas = User.create!(
  first_name: "Tomás",
  last_name: "Araya",
  email_address: "tomas.araya@ejemplo.cl",
  password: default_password,
  password_confirmation: default_password,
  phone_number: "+56 9 6655 4433",
  is_moderator: false
)

puts "=== Creando Propiedades y asignando Comodidades (N:M) ==="
# Propiedad 1: Depto en Providencia (Camila Soto)
prop_providencia = Property.create!(
  user: camila,
  neighborhood: neighborhoods["Providencia"],
  address: "Av. Providencia 1450, Depto 602",
  property_type: :apartment,
  bedrooms_count: 3,
  bathrooms_count: 2,
  shared_spaces: "Living comedor amplio, cocina americana totalmente equipada, terraza con vista a la cordillera y logia con lavadora."
)
prop_providencia.amenities << [
  amenities["Wi-Fi de alta velocidad (Fibra)"],
  amenities["Lavadora y Secadora"],
  amenities["Conserjería 24/7"],
  amenities["Ascensor"],
  amenities["Balcón / Terraza privada"],
  amenities["Bicicletero seguro"]
]

# Propiedad 2: Casona en Ñuñoa (Felipe González)
prop_nunoa_casa = Property.create!(
  user: felipe,
  neighborhood: neighborhoods["Ñuñoa"],
  address: "Av. Manuel Montt 2740",
  property_type: :house,
  bedrooms_count: 4,
  bathrooms_count: 3,
  shared_spaces: "Patio interior con árboles frutales, quincho techado, sala de estar con chimenea, comedor y cocina espaciosa."
)
prop_nunoa_casa.amenities << [
  amenities["Wi-Fi de alta velocidad (Fibra)"],
  amenities["Lavadora y Secadora"],
  amenities["Quincho para asados"],
  amenities["Admite mascotas"],
  amenities["Estacionamiento privado"],
  amenities["Cocina totalmente equipada"]
]

# Propiedad 3: Depto artístico en Barrio Lastarria (Valentina Morales)
prop_lastarria = Property.create!(
  user: valentina,
  neighborhood: neighborhoods["Barrio Lastarria"],
  address: "José Victorino Lastarria 288, Depto 4B",
  property_type: :apartment,
  bedrooms_count: 2,
  bathrooms_count: 1,
  shared_spaces: "Living con piso de parquet patrimonial, balcón colonial con vista a los cafés de la calle, cocina integrada y espacio para trabajo remoto."
)
prop_lastarria.amenities << [
  amenities["Wi-Fi de alta velocidad (Fibra)"],
  amenities["Cocina totalmente equipada"],
  amenities["Calefacción central"],
  amenities["Conserjería 24/7"]
]

# Propiedad 4: Depto moderno en Las Condes (Matías Concha)
prop_las_condes = Property.create!(
  user: matias,
  neighborhood: neighborhoods["Las Condes"],
  address: "Av. Apoquindo 4800, Depto 1205",
  property_type: :apartment,
  bedrooms_count: 3,
  bathrooms_count: 2,
  shared_spaces: "Living minimalista, terraza panorámica, cocina con encimera de inducción. Edificio cuenta con piscina y gimnasio."
)
prop_las_condes.amenities << [
  amenities["Wi-Fi de alta velocidad (Fibra)"],
  amenities["Piscina"],
  amenities["Gimnasio equipado"],
  amenities["Conserjería 24/7"],
  amenities["Ascensor"],
  amenities["Aire acondicionado"],
  amenities["Estacionamiento privado"]
]

# Propiedad 5: Casa taller en Barrio Italia (Ignacia Silva)
prop_italia = Property.create!(
  user: ignacia,
  neighborhood: neighborhoods["Barrio Italia"],
  address: "Santa Isabel 820",
  property_type: :house,
  bedrooms_count: 3,
  bathrooms_count: 2,
  shared_spaces: "Patio interior con plantas, taller de arte iluminado, cocina abierta con isla y comedor común."
)
prop_italia.amenities << [
  amenities["Wi-Fi de alta velocidad (Fibra)"],
  amenities["Admite mascotas"],
  amenities["Lavadora y Secadora"],
  amenities["Bicicletero seguro"]
]

# Propiedad 6: Depto céntrico en Santiago Centro (Camila Soto)
prop_centro = Property.create!(
  user: camila,
  neighborhood: neighborhoods["Santiago Centro"],
  address: "Monjitas 540, Depto 808",
  property_type: :apartment,
  bedrooms_count: 2,
  bathrooms_count: 1,
  shared_spaces: "Living compacto y funcional, cocina americana, vista despejada al Parque Forestal."
)
prop_centro.amenities << [
  amenities["Wi-Fi de alta velocidad (Fibra)"],
  amenities["Conserjería 24/7"],
  amenities["Ascensor"]
]

puts "=== Creando Publicaciones (Listings) en diversos estados ==="
# Montos de arriendo y garantía expresados en UF.
# Propiedad 1 (Providencia): 2 habitaciones en arriendo
listing_prov_master = Listing.create!(
  property: prop_providencia,
  title: "Habitación principal en suite con walk-in closet en Providencia",
  monthly_rent: "9.75",
  deposit: "9.75",
  available_date: Date.current + 7.days,
  minimum_stay_months: 6,
  is_furnished: true,
  has_private_bathroom: true,
  status: :published
)

listing_prov_single = Listing.create!(
  property: prop_providencia,
  title: "Habitación individual luminosa a pasos de Metro Manuel Montt",
  monthly_rent: "7.75",
  deposit: "7.75",
  available_date: Date.current + 14.days,
  minimum_stay_months: 3,
  is_furnished: true,
  has_private_bathroom: false,
  status: :published
)

# Propiedad 2 (Ñuñoa casona): 2 habitaciones (una reservada y una publicada)
listing_nunoa_jardin = Listing.create!(
  property: prop_nunoa_casa,
  title: "Dormitorio amplio con salida directa al jardín en Ñuñoa",
  monthly_rent: "8.00",
  deposit: "8.00",
  available_date: Date.current + 5.days,
  minimum_stay_months: 6,
  is_furnished: true,
  has_private_bathroom: false,
  status: :published
)

listing_nunoa_estudio = Listing.create!(
  property: prop_nunoa_casa,
  title: "Pieza silenciosa ideal para estudiante de postgrado en Ñuñoa",
  monthly_rent: "7.00",
  deposit: "7.00",
  available_date: Date.current + 10.days,
  minimum_stay_months: 12,
  is_furnished: false,
  has_private_bathroom: false,
  status: :reserved
)

# Propiedad 3 (Barrio Lastarria): Habitación muy cotizada (competencia de postulaciones)
listing_lastarria = Listing.create!(
  property: prop_lastarria,
  title: "Habitación con balcón privado en pleno corazón de Barrio Lastarria",
  monthly_rent: "9.00",
  deposit: "9.00",
  available_date: Date.current + 3.days,
  minimum_stay_months: 6,
  is_furnished: true,
  has_private_bathroom: false,
  status: :published
)

# Propiedad 4 (Las Condes): Una publicada y una en borrador (draft)
listing_las_condes_suite = Listing.create!(
  property: prop_las_condes,
  title: "Suite ejecutiva con baño privado y estacionamiento en Las Condes",
  monthly_rent: "11.50",
  deposit: "11.50",
  available_date: Date.current + 20.days,
  minimum_stay_months: 6,
  is_furnished: true,
  has_private_bathroom: true,
  status: :published
)

listing_las_condes_draft = Listing.create!(
  property: prop_las_condes,
  title: "Habitación secundaria en remodelación cerca de Metro Manquehue",
  monthly_rent: "10.00",
  deposit: "10.00",
  available_date: Date.current + 45.days,
  minimum_stay_months: 6,
  is_furnished: false,
  has_private_bathroom: false,
  status: :draft
)

# Propiedad 5 (Barrio Italia): Una habitación ya arrendada (rented)
listing_italia_rented = Listing.create!(
  property: prop_italia,
  title: "Habitación con luz natural en casa de artistas de Barrio Italia",
  monthly_rent: "8.25",
  deposit: "8.25",
  available_date: Date.current + 2.days,
  minimum_stay_months: 6,
  is_furnished: true,
  has_private_bathroom: false,
  status: :rented
)

# Propiedad 6 (Santiago Centro): Una retirada del mercado (withdrawn)
listing_centro_withdrawn = Listing.create!(
  property: prop_centro,
  title: "Pieza acogedora frente a Parque Forestal",
  monthly_rent: "7.25",
  deposit: "7.25",
  available_date: Date.current + 30.days,
  minimum_stay_months: 3,
  is_furnished: true,
  has_private_bathroom: false,
  status: :withdrawn
)

puts "=== Creando Postulaciones (Applications) en todos los estados del ciclo de vida ==="
# Situación 1: Varios postulantes compitiendo por la habitación de Barrio Lastarria
app_lastarria_catalina = Application.create!(
  user: catalina,
  listing: listing_lastarria,
  message: "¡Hola Valentina! Soy Catalina, trabajo como diseñadora gráfica cerca del GAM. Soy muy ordenada, tranquila y me encanta la vibra del barrio.",
  move_in_date: Date.current + 15.days,
  intended_stay_months: 12,
  status: :shortlisted
)
app_lastarria_catalina.update_columns(created_at: 10.days.ago)

app_lastarria_diego = Application.create!(
  user: diego,
  listing: listing_lastarria,
  message: "Hola Valentina, me interesa mucho el espacio. Soy ingeniero, trabajo en formato híbrido y busco un lugar bien ubicado.",
  move_in_date: Date.current + 7.days,
  intended_stay_months: 6,
  status: :pending
)
app_lastarria_diego.update_columns(created_at: 8.days.ago)

app_lastarria_lucas = Application.create!(
  user: lucas,
  listing: listing_lastarria,
  message: "Buenas tardes, me gustaría saber si el arriendo incluye gastos comunes. Trabajo en gastronomía.",
  move_in_date: Date.current + 10.days,
  intended_stay_months: 6,
  status: :rejected
)
app_lastarria_lucas.update_columns(created_at: 12.days.ago)

app_lastarria_sofia = Application.create!(
  user: sofia,
  listing: listing_lastarria,
  message: "Hola, me encanta el departamento, pero finalmente opté por mudarme con una prima. ¡Muchas gracias!",
  move_in_date: Date.current + 20.days,
  intended_stay_months: 6,
  status: :withdrawn
)
app_lastarria_sofia.update_columns(created_at: 9.days.ago)

# Situación 2: Postulación aceptada para la habitación reservada de Ñuñoa
app_nunoa_martin = Application.create!(
  user: martin,
  listing: listing_nunoa_estudio,
  message: "Estimado Felipe, soy estudiante de doctorado en la UC. Busco un ambiente silencioso y respetuoso para estudiar.",
  move_in_date: Date.current + 10.days,
  intended_stay_months: 12,
  status: :accepted
)
app_nunoa_martin.update_columns(created_at: 14.days.ago)

# Situación 3: Postulaciones activas en Providencia
app_prov_diego = Application.create!(
  user: diego,
  listing: listing_prov_master,
  message: "Hola Camila, me gustó mucho la habitación en suite. Trabajo como profesional independiente y tengo excelentes recomendaciones.",
  move_in_date: Date.current + 10.days,
  intended_stay_months: 12,
  status: :shortlisted
)
app_prov_diego.update_columns(created_at: 5.days.ago)

app_prov_florencia = Application.create!(
  user: florencia,
  listing: listing_prov_single,
  message: "Hola! Soy estudiante de último año de kinesiología. Busco un lugar central con buena movilización.",
  move_in_date: Date.current + 14.days,
  intended_stay_months: 6,
  status: :pending
)
app_prov_florencia.update_columns(created_at: 2.days.ago)

# Situación 4: Postulación aceptada en la habitación rentada de Barrio Italia
app_italia_tomas = Application.create!(
  user: tomas,
  listing: listing_italia_rented,
  message: "Hola Ignacia! Trabajo en una agencia en Providencia. Me encantó la casa y el taller.",
  move_in_date: Date.current + 2.days,
  intended_stay_months: 12,
  status: :accepted
)
app_italia_tomas.update_columns(created_at: 15.days.ago)

puts "=== Creando Visitas (Visits) y ejerciendo estados ==="
# Visita completada 1: Catalina en Barrio Lastarria (hace 4 días)
visit_lastarria_catalina = Visit.create!(
  application: app_lastarria_catalina,
  date_time: 4.days.ago,
  status: :completed,
  notes: "Visita realizada con éxito. La postulante conoció los espacios comunes y conversamos sobre las normas de convivencia."
)

# Visita completada 2: Martín en Ñuñoa (hace 6 días)
visit_nunoa_martin = Visit.create!(
  application: app_nunoa_martin,
  date_time: 6.days.ago,
  status: :completed,
  notes: "El postulante visitó la casona y revisó la habitación. Todo en perfecto orden."
)

# Visita completada 3: Tomás en Barrio Italia (hace 7 días)
visit_italia_tomas = Visit.create!(
  application: app_italia_tomas,
  date_time: 7.days.ago,
  status: :completed,
  notes: "Visita presencial completada, excelente sintonía con el grupo de la casa."
)

# Visita confirmada futura: Diego en Providencia
visit_prov_diego = Visit.create!(
  application: app_prov_diego,
  date_time: Time.current + 2.days + 4.hours,
  status: :confirmed,
  notes: "Coordinado para el sábado por la mañana. Se acordó encontrarse en conserjería."
)

# Visita propuesta: Lucas en Barrio Lastarria
visit_lastarria_lucas = Visit.create!(
  application: app_lastarria_lucas,
  date_time: Time.current + 4.days + 2.hours,
  status: :proposed,
  notes: "Horario propuesto por el postulante a la espera de confirmación."
)

# Visita cancelada: Sofía en Barrio Lastarria
visit_lastarria_sofia = Visit.create!(
  application: app_lastarria_sofia,
  date_time: 2.days.ago,
  status: :cancelled,
  notes: "Cancelada por la postulante tras desistir del proceso de arriendo."
)

puts "=== Creando Reseñas (Reviews) 1:1 asociadas a visitas completadas ==="
# Reseña 1: Catalina opina sobre la propiedad de Barrio Lastarria
Review.create!(
  visit: visit_lastarria_catalina,
  property: prop_lastarria,
  user: catalina,
  rating: 5,
  comment: "La propiedad es aún más bella en persona que en las fotos. El ambiente es sumamente tranquilo y Valentina fue muy cordial durante la visita."
)

# Reseña 2: Martín opina sobre la casona en Ñuñoa
Review.create!(
  visit: visit_nunoa_martin,
  property: prop_nunoa_casa,
  user: martin,
  rating: 5,
  comment: "Excelente casona colonial, muy amplia y con áreas verdes impecables. Cumple perfectamente con la tranquilidad que buscaba para estudiar."
)

# Reseña 3: Tomás opina sobre la casa taller en Barrio Italia
Review.create!(
  visit: visit_italia_tomas,
  property: prop_italia,
  user: tomas,
  rating: 4,
  comment: "Muy buena atmósfera y ubicación inmejorable en Barrio Italia. La casa tiene mucha personalidad y las áreas comunes son acogedoras."
)

puts "=== Creando Publicaciones Guardadas (Saved Listings / Favoritos) ==="
SavedListing.create!(user: diego, listing: listing_lastarria)
SavedListing.create!(user: diego, listing: listing_prov_single)
SavedListing.create!(user: catalina, listing: listing_prov_master)
SavedListing.create!(user: sofia, listing: listing_nunoa_jardin)
SavedListing.create!(user: florencia, listing: listing_las_condes_suite)
SavedListing.create!(user: martin, listing: listing_nunoa_estudio)

puts "=== Creando Reportes de Moderación (Reports) ==="
Report.create!(
  user: diego,
  listing: listing_las_condes_draft,
  reason_category: "Información incompleta",
  details: "La publicación parece estar en borrador o sin fotos definitivas de las instalaciones.",
  status: :pending
)

Report.create!(
  user: sofia,
  listing: listing_centro_withdrawn,
  reason_category: "Publicación inactiva",
  details: "El anfitrión retiró el aviso pero aún figuraba en el historial de búsqueda guardado.",
  status: :reviewed
)

Report.create!(
  user: florencia,
  listing: listing_prov_master,
  reason_category: "Consulta sobre gastos comunes",
  details: "Se solicita aclarar si los gastos comunes e internet están incluidos en el monto total del canon de arriendo.",
  status: :action_taken
)

puts "=== Dataset de Seed generado exitosamente ==="
puts "Resumen:"
puts "  - Barrios: #{Neighborhood.count}"
puts "  - Comodidades: #{Amenity.count}"
puts "  - Usuarios: #{User.count} (1 moderador, #{User.where(is_moderator: false).count} regulares)"
puts "  - Propiedades: #{Property.count}"
puts "  - Publicaciones: #{Listing.count} (#{Listing.published.count} publicadas)"
puts "  - Postulaciones: #{Application.count} (#{Application.pending.count} pendientes)"
puts "  - Visitas: #{Visit.count} (#{Visit.completed.count} completadas)"
puts "  - Reseñas: #{Review.count}"
puts "  - Favoritos guardados: #{SavedListing.count}"
puts "  - Reportes de moderación: #{Report.count}"
