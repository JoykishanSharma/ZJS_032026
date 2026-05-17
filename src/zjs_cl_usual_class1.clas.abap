CLASS zjs_cl_usual_class1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    METHODS: display IMPORTING iv_vbeln TYPE vbeln
                     EXPORTING ev_erdat TYPE erdat
                               ev_ernam TYPE ernam
                               ev_vbtyp TYPE vbtyp
                     RAISING   zjs_cx_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZJS_CL_USUAL_CLASS1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    " Entry point when run via F9 in ADT
    DATA: lo_usual_class1 TYPE REF TO zjs_cl_usual_class1.
    TRY.
        CREATE OBJECT lo_usual_class1 TYPE zjs_cl_usual_class1.
        DATA: lv_vbeln TYPE vbeln VALUE 'SO00000000'.
        lo_usual_class1->display(
          EXPORTING
            iv_vbeln = lv_vbeln
          IMPORTING
            ev_erdat = DATA(lv_erdat)
            ev_ernam = DATA(lv_ernam)
            ev_vbtyp = DATA(lv_vbtyp)
        ).

        out->write( |Record Found!| ).
        out->write( | Sales Order : { lv_vbeln }| ).
        out->write( | Created On  : { lv_erdat }| ).
        out->write( | Created By  : { lv_ernam }| ).
        out->write( | Order Type  : { lv_vbtyp }| ).
      CATCH zjs_cx_error INTO DATA(lx_error).
        out->write( lx_error->gv_message ).
    ENDTRY.
  ENDMETHOD.


  METHOD display.

    SELECT SINGLE erdat, ernam, vbtyp
      FROM zjs_vbak
     WHERE vbeln EQ @iv_vbeln
      INTO ( @ev_erdat, @ev_ernam, @ev_vbtyp ).

    IF sy-subrc NE 0.
      RAISE EXCEPTION NEW zjs_cx_error( iv_message = 'Record Not Found!' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
