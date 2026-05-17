CLASS LHC_ZJSR_00FLIGHT DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Flight
        RESULT result,
      validateEmail FOR VALIDATE ON SAVE
            IMPORTING keys FOR Flight~validateEmail.
ENDCLASS.

CLASS LHC_ZJSR_00FLIGHT IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD validateEmail.

    DATA failed_record   LIKE LINE OF failed-flight.
    DATA reported_record LIKE LINE OF reported-flight.

    READ ENTITIES OF zjsr_00flight IN LOCAL MODE
    ENTITY Flight
    FIELDS ( email )
    WITH CORRESPONDING #( keys )
    RESULT DATA(flights).

    LOOP AT flights INTO DATA(flight).
        IF NOT flight-email CP '*@*.*'.
            failed_record-%tky = flight-%tky.
            APPEND failed_record TO failed-flight.
            reported_record-%tky = flight-%tky.
            reported_record-%msg = new_message(
                                     id       = 'ZJS_00_RAP_MSG_CLS'
                                     number   = '001'
                                     severity = ms-error ).
            APPEND reported_record TO reported-flight.
        ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
