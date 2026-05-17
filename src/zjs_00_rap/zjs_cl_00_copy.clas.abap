CLASS zjs_cl_00_copy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS copy_data.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZJS_CL_00_COPY IMPLEMENTATION.


  METHOD copy_data.

    DATA lt_agencies TYPE STANDARD TABLE OF zjsa00flight.

    lt_agencies = VALUE #(

      ( client = sy-mandt
        uuid = cl_system_uuid=>create_uuid_x16_static( )
        agency_id = '070001'
        name = 'Sunshine Travel'
        street = 'Main Street 10'
        city = 'Berlin'
        country_code = 'DE'
        email = 'info@sunshine.de'
        phone = '+49-123456'
        created_by = sy-uname
        created_at = cl_abap_tstmp=>utclong2tstmp_short( utclong = utclong_current( ) )
      )

      ( client = sy-mandt
        uuid = cl_system_uuid=>create_uuid_x16_static( )
        agency_id = '070002'
        name = 'Adventure Tours'
        street = 'Champs Elysees 22'
        city = 'Paris'
        country_code = 'FR'
        email = 'contact@adventure.fr'
        phone = '+33-987654'
        created_by = sy-uname
        created_at = cl_abap_tstmp=>utclong2tstmp_short( utclong = utclong_current( ) )
      )

      ( client = sy-mandt
        uuid = cl_system_uuid=>create_uuid_x16_static( )
        agency_id = '070003'
        name = 'Global Holiday'
        street = '5th Avenue'
        city = 'New York'
        country_code = 'US'
        email = 'hello@globalholiday.com'
        phone = '+1-555-1234'
        created_by = sy-uname
        created_at = cl_abap_tstmp=>utclong2tstmp_short( utclong = utclong_current( ) )
*        created_at = cl_abap_context_info=>get_system_time( )
      )

    ).

    DELETE FROM zjsa00flight WHERE uuid IS NOT INITIAL.
    COMMIT WORK.

    INSERT zjsa00flight FROM TABLE @lt_agencies.
    COMMIT WORK.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    copy_data( ).

  ENDMETHOD.
ENDCLASS.
