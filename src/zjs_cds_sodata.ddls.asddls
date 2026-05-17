@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Data using Parameter'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZJS_CDS_SODATA
  with parameters
    p_vbeln : vbeln_va,
    p_erdat : erdat
  as select from zjs_vbak as zjs_vbak
    inner join   zjs_vbap as zjs_vbap on zjs_vbak.vbeln = zjs_vbap.vbeln
{
  key zjs_vbak.vbeln as vbeln,
  key zjs_vbap.posnr as posnr,
      zjs_vbak.erdat as erdat,
      zjs_vbak.ernam as ernam,
      zjs_vbap.matnr as matnr,
      zjs_vbap.netwr as netwr
}
where
      zjs_vbak.vbeln = $parameters.p_vbeln
  and zjs_vbak.erdat = $parameters.p_erdat;
