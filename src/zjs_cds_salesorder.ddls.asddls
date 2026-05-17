@AbapCatalog.sqlViewName: 'ZJS_SQL_SO'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Sales Order'
@Metadata.ignorePropagatedAnnotations: true
define view ZJS_CDS_SALESORDER as select from zjs_vbak
{
    key zjs_vbak.vbeln, zjs_vbak.ernam 
}
