variable "name" {
  type = object({
    family_name = string           # The user's last name.
    given_name  = optional(string) # The user's first name.
  })
  description = "(Block List, Min: 1, Max: 1) Holds the given and family names of the user, and the read-only fullName value."
  default     = { family_name = null }
}

variable "primary_email" {
  type        = string
  description = "The user's primary email address. The primaryEmail must be unique and cannot be an alias of another user."
  default     = null
}

variable "addresses" {
  type = list(object({
    type                 = string           # The address type.
    country              = optional(string) # Country
    country_code         = optional(string) # The country code. Uses the ISO 3166-1 standard.
    custom_type          = optional(string) # If the address type is custom, this property contains the custom value.
    extended_address     = optional(string) # For extended addresses, such as an address that includes a sub-region.
    formatted            = optional(string) # A full and unstructured postal address. This is not synced with the structured address fields.
    locality             = optional(string) # The town or city of the address.
    po_box               = optional(string) # The post office box, if present.
    postal_code          = optional(string) # The ZIP or postal code, if applicable.
    primary              = optional(bool)   # If this is the user's primary address. The addresses list may contain only one primary address.
    region               = optional(string) # The abbreviated province or state.
    source_is_structured = optional(bool)   # Indicates if the user-supplied address was formatted. Formatted addresses are not currently supported.
    street_address       = optional(string) # The street address, such as 1600 Amphitheatre Parkway.
  }))
  description = "A list of the user's addresses."
  default     = [{ type = null }]
  validation {
    condition = alltrue(concat(
      [
        for address in var.addresses :
        contains(
          [
            "custom",
            "home",
            "other",
            "work",
          ],
          address.type != null ? address.type : "work"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type
  * custom
  * home
  * other
  * work
EOT
  }
}

variable "aliases" {
  type        = list(string)
  description = "List of the user's alias email addresses."
  default     = []
}

variable "archived" {
  type        = bool
  description = "Indicates if user is archived."
  default     = null
}

variable "change_password_at_next_login" {
  type        = bool
  description = "Indicates if the user is forced to change their password at next login."
  default     = null
}

variable "custom_schemas" {
  type = list(object({
    schema_name   = string      # The name of the schema.
    schema_values = map(string) # JSON encoded map that represents key/value pairs that correspond to the given schema.
  }))
  description = "Custom fields of the user."
  default     = [{ schema_name = null, schema_values = {} }]
}

variable "emails" {
  type = list(object({
    type        = string           # The type of the email account.
    address     = optional(string) # The user's email address. Also serves as the email ID. This value can be the user's primary email address or an alias.
    custom_type = optional(string) # If the value of type is custom, this property contains the custom type string.
    primary     = optional(bool)   # Defaults to false. Indicates if this is the user's primary email. Only one entry can be marked as primary.
  }))
  description = "A list of the user's email addresses."
  default     = [{ type = null }]
  validation {
    condition = alltrue(concat(
      [
        for email in var.emails :
        contains(
          [
            "custom",
            "home",
            "other",
            "work",
          ],
          email.type != null ? email.type : "work"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type
  * custom
  * home
  * other
  * work
EOT
  }
}

variable "external_ids" {
  type = list(object({
    type        = string           # The type of external ID. If set to custom, customType must also be set. Acceptable values: account, custom, customer, login_id, network, organization.
    value       = string           # The value of the ID.
    custom_type = optional(string) # If the external ID type is custom, this property contains the custom value and must be set.
  }))
  description = "A list of external IDs for the user, such as an employee or network ID."
  default     = [{ type = null, value = null }]
  validation {
    condition = alltrue(concat(
      [
        for external_id in var.external_ids :
        contains(
          [
            "account",
            "custom",
            "customer",
            "login_id",
            "network",
            "organization",
          ],
          external_id.type != null ? external_id.type : "login_id"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type
  * account
  * custom
  * customer
  * login_id
  * network
  * organization
EOT
  }
}

variable "hash_function" {
  type        = string
  description = "Stores the hash format of the password property. We recommend sending the password property value as a base 16 bit hexadecimal-encoded hash value. Set the hashFunction values as either the SHA-1, MD5, or crypt hash format."
  default     = null
}

variable "ims" {
  type = list(object({
    protocol        = string           # An IM protocol identifies the IM network. Acceptable values: aim, custom_protocol, gtalk, icq, jabber, msn, net_meeting, qq, skype, yahoo.
    type            = string           # Acceptable values: custom, home, other, work.
    custom_protocol = optional(string) # If the protocol value is custom_protocol, this property holds the custom protocol's string.
    custom_type     = optional(string) # If the IM type is custom, this property holds the custom type string.
    im              = optional(string) # The user's IM network ID.
    primary         = optional(bool)   # If this is the user's primary IM. Only one entry in the IM list can have a value of true.
  }))
  description = "The user's Instant Messenger (IM) accounts. A user account can have multiple ims properties. But, only one of these ims properties can be the primary IM contact."
  default     = [{ protocol = null, type = null }]
  validation {
    condition = alltrue(concat(
      [
        for im in var.ims :
        contains(
          [
            "aim",
            "custom_protocol",
            "gtalk",
            "icq",
            "jabber",
            "msn",
            "net_meeting",
            "qq",
            "skype",
            "yahoo",
          ],
          im.protocol != null ? im.protocol : "skype"
        )
      ],
      [
        for im in var.ims :
        contains(
          [
            "custom",
            "home",
            "other",
            "work",
          ],
          im.type != null ? im.type : "work"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* protocol
  * aim
  * custom_protocol
  * gtalk
  * icq
  * jabber
  * msn
  * net_meeting
  * qq
  * skype
  * yahoo
* type
  * custom
  * home
  * other
  * work
EOT
  }
}

variable "include_in_global_address_list" {
  type        = bool
  description = "Defaults to true. Indicates if the user's profile is visible in the Google Workspace global address list when the contact sharing feature is enabled for the domain."
  default     = null
}

variable "ip_allowlist" {
  type        = bool
  description = "If true, the user's IP address is added to the allow list."
  default     = null
}

variable "is_admin" {
  type        = bool
  description = "Indicates a user with super admininistrator privileges."
  default     = null
}

variable "keywords" {
  type = list(object({
    type        = string           # Each entry can have a type which indicates standard type of that entry.
    value       = string           # Keyword.
    custom_type = optional(string) # Custom Type.
  }))
  description = "A list of the user's keywords."
  default     = [{ type = null, value = null }]
  validation {
    condition = alltrue(concat(
      [
        for keyword in var.keywords :
        contains(
          [
            "custom",
            "mission",
            "occupation",
            "outlook",
          ],
          keyword.type != null ? keyword.type : "occupation"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type
  * custom
  * mission
  * occupation
  * outlook
EOT
  }
}

variable "languages" {
  type = list(object({
    custom_language = optional(string) # Other language. A user can provide their own language name if there is no corresponding Google III language code. If this is set, LanguageCode can't be set.
    language_code   = optional(string) # Defaults to en. Should be used for storing Google III LanguageCode string representation for language. Illegal values cause SchemaException.
    preference      = optional(string) # Defaults to preferred. If present, controls whether the specified languageCode is the user's preferred language. Allowed values are preferred and not_preferred.
  }))
  description = "A list of the user's languages."
  default     = []
}

variable "locations" {
  type = list(object({
    type          = string           # The location type.
    area          = optional(string) # Textual location. This is most useful for display purposes to concisely describe the location. For example, Mountain View, CA or Near Seattle.
    building_id   = optional(string) # Building identifier.
    custom_type   = optional(string) # If the location type is custom, this property contains the custom value.
    desk_code     = optional(string) # Most specific textual code of individual desk location.
    floor_name    = optional(string) # Floor name/number.
    floor_section = optional(string) # Floor section. More specific location within the floor. For example, if a floor is divided into sections A, B, and C, this field would identify one of those values.
  }))
  description = "A list of the user's locations."
  default     = []
  validation {
    condition = alltrue(concat(
      [
        for location in var.locations :
        contains(
          [
            "custom",
            "default",
            "desk",
          ],
          location.type != null ? location.type : "default"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type
  * custom
  * default
  * desk
EOT
  }
}

variable "org_unit_path" {
  type        = string
  description = "The full path of the parent organization associated with the user. If the parent organization is the top-level, it is represented as a forward slash (/)."
  default     = null
}

variable "organizations" {
  type = list(object({
    type                 = string           # The type of organization. Acceptable values: domain_only, school, unknown, work.
    cost_center          = optional(string) # The cost center of the user's organization.
    custom_type          = optional(string) # If the value of type is custom, this property contains the custom value.
    department           = optional(string) # Specifies the department within the organization, such as sales or engineering.
    description          = optional(string) # The description of the organization.
    domain               = optional(string) # The domain the organization belongs to.
    full_time_equivalent = optional(number) # The full-time equivalent millipercent within the organization (100000 = 100%)
    location             = optional(string) # The physical location of the organization. This does not need to be a fully qualified address.
    name                 = optional(string) # The name of the organization.
    primary              = optional(bool)   # Indicates if this is the user's primary organization. A user may only have one primary organization.
    symbol               = optional(string) # Text string symbol of the organization. For example, the text symbol for Google is GOOG.
    title                = optional(string) # The user's title within the organization. For example, member or engineer.
  }))
  description = "A list of organizations the user belongs to."
  default     = []
  validation {
    condition = alltrue(concat(
      [
        for organization in var.organizations :
        contains(
          [
            "domain_only",
            "school",
            "unknown",
            "work",
          ],
          organization.type != null ? organization.type : "work"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type
  * domain_only
  * school
  * unknown
  * work
EOT
  }
}

variable "password" {
  type        = string
  description = "Stores the password for the user account. A password can contain any combination of ASCII characters. A minimum of 8 characters is required."
  default     = null
}

variable "phones" {
  type = list(object({
    type        = string           # The type of phone number.
    value       = string           # A human-readable phone number. It may be in any telephone number format.
    custom_type = optional(string) # If the phone number type is custom, this property contains the custom value and must be set.
    primary     = optional(bool)   # Indicates if this is the user's primary phone number. A user may only have one primary phone number.
  }))
  description = "A list of the user's phone numbers."
  default     = []
  validation {
    condition = alltrue(concat(
      [
        for phone in var.phones :
        contains(
          [
            "assistant",
            "callback",
            "car",
            "company_main",
            "custom",
            "grand_central",
            "home",
            "home_fax",
            "isdn",
            "main",
            "mobile",
            "other",
            "other_fax",
            "pager",
            "radio",
            "telex",
            "tty_tdd",
            "work",
            "work_fax",
            "work_mobile",
            "work_pager",
          ],
          phone.type != null ? phone.type : "work"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type
  * assistant
  * callback
  * car
  * company_main
  * custom
  * grand_central
  * home
  * home_fax
  * isdn
  * main
  * mobile
  * other
  * other_fax
  * pager
  * radio
  * telex
  * tty_tdd
  * work
  * work_fax
  * work_mobile
  * work_pager
EOT
  }
}

variable "posix_accounts" {
  type = list(object({
    account_id            = optional(string) # A POSIX account field identifier.
    gecos                 = optional(string) # The GECOS (user information) for this account.
    gid                   = optional(string) # The default group ID.
    home_directory        = optional(string) # The path to the home directory for this account.
    operating_system_type = optional(string) # The operating system type for this account. Acceptable values: linux, unspecified, windows
    primary               = optional(bool)   # If this is user's primary account within the SystemId.
    shell                 = optional(string) # The path to the login shell for this account.
    system_id             = optional(string) # System identifier for which account Username or Uid apply to.
    uid                   = optional(string) # The POSIX compliant user ID.
    username              = optional(string) # The username of the account.
  }))
  description = "A list of POSIX account information for the user."
  default     = []
}

variable "recovery_email" {
  type        = string
  description = "Recovery email of the user."
  default     = null
}

variable "recovery_phone" {
  type        = string
  description = "Recovery phone of the user. The phone number must be in the E.164 format, starting with the plus sign (+). Example: +16506661212."
  default     = null
}

variable "relations" {
  type = list(object({
    type        = string           # The type of relation.
    value       = string           # The name of the person the user is related to.
    custom_type = optional(string) # If the value of type is custom, this property contains the custom type string.
  }))
  description = "A list of the user's relationships to other users."
  default     = [{ type = null, value = null }]
  validation {
    condition = alltrue(concat(
      [
        for relation in var.relations :
        contains(
          [
            "admin_assistant",
            "assistant",
            "brother",
            "child",
            "custom",
            "domestic_partner",
            "dotted_line_manager",
            "exec_assistant",
            "father",
            "friend",
            "manager",
            "mother",
            "parent",
            "partner",
            "referred_by",
            "relative",
            "sister",
            "spouse",
          ],
          relation.type != null ? relation.type : "manager"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type
  * admin_assistant
  * assistant
  * brother
  * child
  * custom
  * domestic_partner
  * dotted_line_manager
  * exec_assistant
  * father
  * friend
  * manager
  * mother
  * parent
  * partner
  * referred_by
  * relative
  * sister
  * spouse
EOT
  }
}

variable "ssh_public_keys" {
  type = list(object({
    key                  = string           # An SSH public key.
    expiration_time_usec = optional(string) # An expiration time in microseconds since epoch.
  }))
  description = "A list of SSH public keys."
  default     = [{ key = null }]
}

variable "suspended" {
  type        = bool
  description = "Indicates if user is suspended."
  default     = null
}

variable "websites" {
  type = list(object({
    type        = string           # The type or purpose of the website.
    value       = string           # The URL of the website.
    custom_type = optional(string) # The custom type. Only used if the type is custom.
    primary     = optional(bool)   # If this is user's primary website or not.
  }))
  description = "A list of the user's websites."
  default     = [{ type = null, value = null }]
  validation {
    condition = alltrue(concat(
      [
        for website in var.websites :
        contains(
          [
            "app_install_page",
            "blog",
            "custom",
            "ftp",
            "home",
            "home_page",
            "other",
            "profile",
            "reservations",
            "resume",
            "work",
          ],
          website.type != null ? website.type : "home"
        )
      ],
    ))
    error_message = <<EOT
Possible values are:
* type:
  * app_install_page
  * blog
  * custom
  * ftp
  * home
  * home_page
  * other
  * profile
  * reservations
  * resume
  * work
EOT
  }
}

variable "timeouts" {
  type = object({
    create = optional(string)
    update = optional(string)
  })
  description = "Timeouts block."
  default     = null
}
