FUNCTION zjs_fm_call_usual_class1.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VBELN) TYPE  VBELN
*"  EXPORTING
*"     VALUE(ES_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------
  DATA: lo_usual_class1 TYPE REF TO zjs_cl_usual_class1,
        lv_erdat        TYPE erdat,
        lv_ernam        TYPE ernam,
        lv_vbtyp        TYPE vbtyp.

  TRY.
      CALL METHOD lo_usual_class1->display
        EXPORTING
          iv_vbeln = iv_vbeln
        IMPORTING
          ev_erdat = lv_erdat
          ev_ernam = lv_ernam
          ev_vbtyp = lv_vbtyp.
    CATCH zjs_cx_error INTO DATA(lo_error).
        es_return-id = 'E'.
        es_return-message = lo_error->gv_message.
  ENDTRY.


ENDFUNCTION.
