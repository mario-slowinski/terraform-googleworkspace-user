resource "googleworkspace_user" "primary_email" {
  for_each = var.primary_email != null ? toset([var.primary_email]) : toset([])

  dynamic "name" {
    for_each    = var.name.family_name != null ? toset([var.name]) : toset([])
    family_name = name.value.family_name
    given_name  = name.value.given_name
  }

  primary_email = each.value

  dynamic "addresses" {
    for_each = { for index, address in var.addresses : index => address if address.type != null }

    type                 = addresses.value.type
    country              = addresses.value.country
    country_code         = addresses.value.country_code
    custom_type          = addresses.value.custom_type
    extended_address     = addresses.value.extended_address
    formatted            = addresses.value.formatted
    locality             = addresses.value.locality
    po_box               = addresses.value.po_box
    postal_code          = addresses.value.postal_code
    primary              = addresses.value.primary
    region               = addresses.value.region
    source_is_structured = addresses.value.source_is_structured
    street_address       = addresses.value.street_address
  }

  aliases                       = var.aliases
  archived                      = var.archived
  change_password_at_next_login = var.change_password_at_next_login

  dynamic "custom_schemas" {
    for_each = { for custom_schema in var.custom_schemas : custom_schema.name => custom_schema if custom_schema.name != null }

    schema_name   = custom_schemas.value.schema_name
    schema_values = custom_schemas.value.schema_values
  }

  dynamic "emails" {
    for_each = { for index, email in var.emails : index => email if email.type != null }

    type        = emails.value.type
    address     = emails.value.address
    custom_type = emails.value.custom_type
    primary     = emails.value.primary
  }

  dynamic "external_ids" {
    for_each = { for index, external_id in var.external_ids : index => external_id if external_id.type != null }

    type        = external_ids.value.type
    value       = external_ids.value.value
    custom_type = external_ids.value.custom_type
  }

  hash_function = var.hash_function

  dynamic "ims" {
    for_each = { for index, im in var.ims : index => im if im.protocol != null }

    protocol        = ims.value.protocol
    type            = ims.value.type
    custom_protocol = ims.value.custom_protocol
    custom_type     = ims.value.custom_type
    im              = ims.value.im
    primary         = ims.value.primary
  }

  include_in_global_address_list = var.include_in_global_address_list
  ip_allowlist                   = var.ip_allowlist
  is_admin                       = var.is_admin

  dynamic "keywords" {
    for_each = { for index, keyword in var.keywords : index => keyword if keyword.type != null }

    type        = keyword.value.type
    value       = keyword.value.value
    custom_type = keyword.value.custom_type
  }

  dynamic "languages" {
    for_each = { for index, language in var.languages : index => language }

    custom_language = languages.value.custom_language
    language_code   = languages.value.language_code
    preference      = languages.value.preference
  }

  dynamic "locations" {
    for_each = { for index, location in var.locations : index => location }

    type          = locations.value.type
    area          = locations.value.area
    building_id   = locations.value.building_id
    custom_type   = locations.value.custom_type
    desk_code     = locations.value.desk_code
    floor_name    = locations.value.floor_name
    floor_section = locations.value.floor_section
  }

  org_unit_path = var.org_unit_path

  dynamic "organizations" {
    for_each = { for index, organization in var.organizations : index => organization }

    type                 = organizations.value.type
    cost_center          = organizations.value.cost_center
    custom_type          = organizations.value.custom_type
    department           = organizations.value.department
    description          = organizations.value.description
    domain               = organizations.value.domain
    full_time_equivalent = organizations.value.full_time_equivalent
    location             = organizations.value.location
    name                 = organizations.value.name
    primary              = organizations.value.primary
    symbol               = organizations.value.symbol
    title                = organizations.value.title
  }

  password = var.password

  dynamic "phones" {
    for_each = { for index, phone in var.phones : index => phone }

    type        = phones.value.type
    value       = phones.value.value
    custom_type = phones.value.custom_type
    primary     = phones.value.primary
  }

  dynamic "posix_accounts" {
    for_each = { for index, posix_account in var.posix_accounts : index => posix_account }

    account_id            = posix_accounts.value.account_id
    gecos                 = posix_accounts.value.gecos
    gid                   = posix_accounts.value.gid
    home_directory        = posix_accounts.value.home_directory
    operating_system_type = posix_accounts.value.operating_system_type
    primary               = posix_accounts.value.primary
    shell                 = posix_accounts.value.shell
    system_id             = posix_accounts.value.system_id
    uid                   = posix_accounts.value.uid
    username              = posix_accounts.value.username
  }

  recovery_email = var.recovery_email
  recovery_phone = var.recovery_phone

  dynamic "relations" {
    for_each = { for index, relation in var.relations : index => relation }

    type        = relations.value.type
    value       = relations.value.value
    custom_type = relations.value.custom_type
  }

  dynamic "ssh_public_keys" {
    for_each = { for index, ssh_public_key in var.ssh_public_keys : index => ssh_public_key }

    key                  = ssh_public_keys.value.key
    expiration_time_usec = ssh_public_keys.value.expiration_time_usec
  }

  suspended = var.suspended

  dynamic "websites" {
    for_each = { for index, website in var.websites : index => website }

    type        = websites.value.type
    value       = websites.value.value
    custom_type = websites.value.custom_type
    primary     = websites.value.primary
  }
}
