CLASS zjs_cx_error DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: gv_message TYPE string.

    METHODS constructor
      IMPORTING
        iv_message TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZJS_CX_ERROR IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( ).
    me->gv_message = iv_message.
  ENDMETHOD.
ENDCLASS.
