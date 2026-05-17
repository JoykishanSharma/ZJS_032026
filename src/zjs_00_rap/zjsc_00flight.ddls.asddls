@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZJSC_00FLIGHT
  provider contract TRANSACTIONAL_QUERY
  as projection on ZJSR_00FLIGHT
  association [1..1] to ZJSR_00FLIGHT as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
  AgencyID,
  Name,
  Street,
  City,
  CountryCode,
  Email,
  Phone,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Lastchangedby: true
  }
  LastChangedBy,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  _BaseEntity
}
