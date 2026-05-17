CLASS zjs_dummy_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS:
      generate_all,
      generate_materials,
      generate_marc,
      generate_customers,
      generate_vendors,
      generate_sales_orders,
      generate_purchase_orders,
      cleanup_all.

  PRIVATE SECTION.
    CONSTANTS:
      gc_num_materials TYPE i VALUE 50,
      gc_num_customers TYPE i VALUE 20,
      gc_num_vendors   TYPE i VALUE 15,
      gc_num_so        TYPE i VALUE 30,
      gc_num_po        TYPE i VALUE 20.

    DATA: mv_seed TYPE int8 VALUE 42.

    METHODS:
      get_random_int
        IMPORTING iv_min        TYPE i
                  iv_max        TYPE i
        RETURNING VALUE(rv_val) TYPE i,
      get_random_date
        IMPORTING iv_year_from  TYPE i DEFAULT 2022
                  iv_year_to    TYPE i DEFAULT 2025
        RETURNING VALUE(rv_dat) TYPE d.

ENDCLASS.



CLASS ZJS_DUMMY_DATA_GENERATOR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    " Entry point when run via F9 in ADT
    cleanup_all( ).
    generate_all( ).
    out->write( |Dummy data generation complete.| ).
    out->write( |  Materials : { gc_num_materials }| ).
    out->write( |  Customers : { gc_num_customers }| ).
    out->write( |  Vendors   : { gc_num_vendors }| ).
    out->write( |  Sales Ord.: { gc_num_so }| ).
    out->write( |  Purch.Ord.: { gc_num_po }| ).
  ENDMETHOD.


  METHOD generate_all.
    generate_materials( ).
    generate_marc( ).
    generate_customers( ).
    generate_vendors( ).
    generate_sales_orders( ).
    generate_purchase_orders( ).
  ENDMETHOD.


  METHOD generate_materials.

    TYPES: BEGIN OF ty_mat_template,
             name  TYPE c LENGTH 40,
             mtart TYPE c LENGTH 4,
             matkl TYPE c LENGTH 9,
             meins TYPE c LENGTH 3,
           END OF ty_mat_template.

    DATA: lt_templates TYPE STANDARD TABLE OF ty_mat_template,
          lt_mara      TYPE STANDARD TABLE OF zjs_mara.

    lt_templates = VALUE #(
      ( name = 'Steel Bolt M8x50'         mtart = 'HAWA' matkl = 'FASTENER' meins = 'PC' )
      ( name = 'Copper Wire 2.5mm'        mtart = 'ROH'  matkl = 'ELECTRIC' meins = 'M'  )
      ( name = 'Hydraulic Pump HP-200'    mtart = 'HALB' matkl = 'MECHANIC' meins = 'PC' )
      ( name = 'Laptop ProBook X1'        mtart = 'FERT' matkl = 'IT_HW'    meins = 'PC' )
      ( name = 'Office Chair Ergo'        mtart = 'HAWA' matkl = 'FURNIT'   meins = 'PC' )
      ( name = 'Bearing SKF 6205'         mtart = 'ROH'  matkl = 'MECHANIC' meins = 'PC' )
      ( name = 'Aluminum Sheet 2mm'       mtart = 'ROH'  matkl = 'METALS'   meins = 'KG' )
      ( name = 'Plastic Granulate ABS'    mtart = 'ROH'  matkl = 'PLASTICS' meins = 'KG' )
      ( name = 'Servo Motor SM-100'       mtart = 'HALB' matkl = 'ELECTRIC' meins = 'PC' )
      ( name = 'Packaging Box L'          mtart = 'VERP' matkl = 'PACKAG'   meins = 'PC' )
      ( name = 'LED Display Panel 27in'   mtart = 'FERT' matkl = 'IT_HW'    meins = 'PC' )
      ( name = 'Carbon Fiber Rod 10mm'    mtart = 'ROH'  matkl = 'COMPOSI'  meins = 'M'  )
      ( name = 'Gear Module 2.0'          mtart = 'HALB' matkl = 'MECHANIC' meins = 'PC' )
      ( name = 'Thermal Paste TG-5'       mtart = 'HAWA' matkl = 'IT_HW'    meins = 'PC' )
      ( name = 'Safety Helmet Type A'     mtart = 'HAWA' matkl = 'SAFETY'   meins = 'PC' )
      ( name = 'Rubber Seal Ring DN50'    mtart = 'ROH'  matkl = 'SEALS'    meins = 'PC' )
      ( name = 'Stainless Pipe DN25'      mtart = 'ROH'  matkl = 'METALS'   meins = 'M'  )
      ( name = 'Electric Motor 5kW'       mtart = 'HALB' matkl = 'ELECTRIC' meins = 'PC' )
      ( name = 'Printer LaserJet Pro'     mtart = 'FERT' matkl = 'IT_HW'    meins = 'PC' )
      ( name = 'Welding Rod 3.2mm'        mtart = 'HAWA' matkl = 'WELD'     meins = 'KG' )
    ).

    DATA(lv_tpl_count) = lines( lt_templates ).

    DO gc_num_materials TIMES.
      DATA(lv_idx) = sy-index.
      DATA(lv_tpl_idx) = ( ( lv_idx - 1 ) MOD lv_tpl_count ) + 1.
      READ TABLE lt_templates INTO DATA(ls_tpl) INDEX lv_tpl_idx.

      APPEND VALUE zjs_mara(
        client = sy-mandt
        matnr  = |MAT{ lv_idx WIDTH = 6 ALIGN = RIGHT PAD = '0' }|
        maktx  = COND #( WHEN lv_idx <= lv_tpl_count
                         THEN ls_tpl-name
                         ELSE |{ ls_tpl-name } V{ lv_idx }| )
        mtart  = ls_tpl-mtart
        matkl  = ls_tpl-matkl
        meins  = ls_tpl-meins
        brgew  = get_random_int( iv_min = 1 iv_max = 500 ) / 10
        ntgew  = get_random_int( iv_min = 1 iv_max = 400 ) / 10
        gewei  = 'KG'
        ersda  = get_random_date( )
        laeda  = get_random_date( iv_year_from = 2024 )
      ) TO lt_mara.
    ENDDO.

    INSERT zjs_mara FROM TABLE @lt_mara.

  ENDMETHOD.


  METHOD generate_marc.

    DATA: lt_marc   TYPE STANDARD TABLE OF zjs_marc,
          lt_plants TYPE STANDARD TABLE OF werks_d.

    lt_plants = VALUE #( ( '1000' ) ( '2000' ) ( '3000' ) ).

    SELECT matnr FROM zjs_mara INTO TABLE @DATA(lt_matnr).

    LOOP AT lt_matnr INTO DATA(ls_mat).
      DATA(lv_plant_count) = get_random_int( iv_min = 1 iv_max = 3 ).
      DO lv_plant_count TIMES.
        READ TABLE lt_plants INTO DATA(lv_plant) INDEX sy-index.
        APPEND VALUE zjs_marc(
          client = sy-mandt
          matnr  = ls_mat-matnr
          werks  = lv_plant
          dismm  = COND #( WHEN get_random_int( iv_min = 1 iv_max = 2 ) = 1
                           THEN 'PD' ELSE 'VB' )
          dispo  = |D{ get_random_int( iv_min = 1 iv_max = 5 ) WIDTH = 2
                       ALIGN = RIGHT PAD = '0' }|
          ekgrp  = |E{ get_random_int( iv_min = 1 iv_max = 9 ) WIDTH = 2
                       ALIGN = RIGHT PAD = '0' }|
          plifz  = get_random_int( iv_min = 3 iv_max = 30 )
        ) TO lt_marc.
      ENDDO.
    ENDLOOP.

    INSERT ZJS_marc  FROM TABLE @lt_marc.

  ENDMETHOD.


  METHOD generate_customers.

    TYPES: BEGIN OF ty_cust_tpl,
             name1 TYPE c LENGTH 35,
             ort01 TYPE c LENGTH 35,
             land1 TYPE c LENGTH 3,
           END OF ty_cust_tpl.

    DATA: lt_tpl  TYPE STANDARD TABLE OF ty_cust_tpl,
          lt_kna1 TYPE STANDARD TABLE OF ZJS_kna1.

    lt_tpl = VALUE #(
      ( name1 = 'Acme Corp'            ort01 = 'New York'    land1 = 'US' )
      ( name1 = 'TechVision GmbH'      ort01 = 'Munich'      land1 = 'DE' )
      ( name1 = 'Sakura Industries'     ort01 = 'Tokyo'       land1 = 'JP' )
      ( name1 = 'Nordic Solutions AB'   ort01 = 'Stockholm'   land1 = 'SE' )
      ( name1 = 'Greenfield Ltd'        ort01 = 'London'      land1 = 'GB' )
      ( name1 = 'Atlas Manufacturing'   ort01 = 'Chicago'     land1 = 'US' )
      ( name1 = 'Rhine Logistics'       ort01 = 'Dusseldorf'  land1 = 'DE' )
      ( name1 = 'Pacific Trading Co'    ort01 = 'Sydney'      land1 = 'AU' )
      ( name1 = 'Maple Systems Inc'     ort01 = 'Toronto'     land1 = 'CA' )
      ( name1 = 'Solaris Energy'        ort01 = 'Madrid'      land1 = 'ES' )
      ( name1 = 'Blue Ocean Shipping'   ort01 = 'Singapore'   land1 = 'SG' )
      ( name1 = 'Alpine Precision AG'   ort01 = 'Zurich'      land1 = 'CH' )
      ( name1 = 'Dragon Electronics'    ort01 = 'Shenzhen'    land1 = 'CN' )
      ( name1 = 'Falcon Aerospace'      ort01 = 'Seattle'     land1 = 'US' )
      ( name1 = 'Vikram Industries'     ort01 = 'Mumbai'      land1 = 'IN' )
      ( name1 = 'Fjord Consulting'      ort01 = 'Oslo'        land1 = 'NO' )
      ( name1 = 'Sahara Mining Corp'    ort01 = 'Johannesburg' land1 = 'ZA' )
      ( name1 = 'Bamboo Software'       ort01 = 'Seoul'       land1 = 'KR' )
      ( name1 = 'EuroSteel SA'          ort01 = 'Paris'       land1 = 'FR' )
      ( name1 = 'Terra Construction'    ort01 = 'Sao Paulo'   land1 = 'BR' )
    ).

    DO gc_num_customers TIMES.
      DATA(lv_idx) = sy-index.
      DATA(lv_tpl_idx) = ( ( lv_idx - 1 ) MOD lines( lt_tpl ) ) + 1.
      READ TABLE lt_tpl INTO DATA(ls_tpl) INDEX lv_tpl_idx.

      APPEND VALUE ZJS_kna1(
        client = sy-mandt
        kunnr  = |C{ lv_idx WIDTH = 9 ALIGN = RIGHT PAD = '0' }|
        name1  = ls_tpl-name1
        name2  = |Division { lv_idx }|
        ort01  = ls_tpl-ort01
        pstlz  = |{ get_random_int( iv_min = 10000 iv_max = 99999 ) }|
        land1  = ls_tpl-land1
        regio  = |{ get_random_int( iv_min = 1 iv_max = 16 ) WIDTH = 2
                     ALIGN = RIGHT PAD = '0' }|
        spras  = 'E'
        telf1  = |+{ get_random_int( iv_min = 100 iv_max = 999 ) }-{
                     get_random_int( iv_min = 1000000 iv_max = 9999999 ) }|
        erdat  = get_random_date( )
      ) TO lt_kna1.
    ENDDO.

    INSERT ZJS_kna1 FROM TABLE @lt_kna1.

  ENDMETHOD.


  METHOD generate_vendors.

    TYPES: BEGIN OF ty_vend_tpl,
             name1 TYPE c LENGTH 35,
             ort01 TYPE c LENGTH 35,
             land1 TYPE c LENGTH 3,
           END OF ty_vend_tpl.

    DATA: lt_tpl  TYPE STANDARD TABLE OF ty_vend_tpl,
          lt_lfa1 TYPE STANDARD TABLE OF ZJS_lfa1.

    lt_tpl = VALUE #(
      ( name1 = 'Global Steel Supply'    ort01 = 'Pittsburgh'  land1 = 'US' )
      ( name1 = 'Precision Parts GmbH'   ort01 = 'Stuttgart'   land1 = 'DE' )
      ( name1 = 'Eastern Components'     ort01 = 'Shanghai'    land1 = 'CN' )
      ( name1 = 'Nordic Fasteners AB'    ort01 = 'Gothenburg'  land1 = 'SE' )
      ( name1 = 'MegaChip Semiconductors' ort01 = 'Taipei'     land1 = 'TW' )
      ( name1 = 'Rhein Chemicals AG'     ort01 = 'Basel'       land1 = 'CH' )
      ( name1 = 'Southern Rubber Co'     ort01 = 'Bangkok'     land1 = 'TH' )
      ( name1 = 'Pacific Wire Ltd'       ort01 = 'Auckland'    land1 = 'NZ' )
      ( name1 = 'Euro Packaging SRL'     ort01 = 'Milan'       land1 = 'IT' )
      ( name1 = 'Maple Wood Products'    ort01 = 'Vancouver'   land1 = 'CA' )
      ( name1 = 'Bengal Textiles'        ort01 = 'Dhaka'       land1 = 'BD' )
      ( name1 = 'Iberian Motors SA'      ort01 = 'Barcelona'   land1 = 'ES' )
      ( name1 = 'Outback Mining Supply'  ort01 = 'Perth'       land1 = 'AU' )
      ( name1 = 'Fjord Fish Oil AS'      ort01 = 'Bergen'      land1 = 'NO' )
      ( name1 = 'Tata Industrial Parts'  ort01 = 'Pune'        land1 = 'IN' )
    ).

    DO gc_num_vendors TIMES.
      DATA(lv_idx) = sy-index.
      DATA(lv_tpl_idx) = ( ( lv_idx - 1 ) MOD lines( lt_tpl ) ) + 1.
      READ TABLE lt_tpl INTO DATA(ls_tpl) INDEX lv_tpl_idx.

      APPEND VALUE ZJS_lfa1(
        client = sy-mandt
        lifnr  = |V{ lv_idx WIDTH = 9 ALIGN = RIGHT PAD = '0' }|
        name1  = ls_tpl-name1
        name2  = |Dept { lv_idx }|
        ort01  = ls_tpl-ort01
        pstlz  = |{ get_random_int( iv_min = 10000 iv_max = 99999 ) }|
        land1  = ls_tpl-land1
        regio  = |{ get_random_int( iv_min = 1 iv_max = 16 ) WIDTH = 2
                     ALIGN = RIGHT PAD = '0' }|
        telf1  = |+{ get_random_int( iv_min = 100 iv_max = 999 ) }-{
                     get_random_int( iv_min = 1000000 iv_max = 9999999 ) }|
        erdat  = get_random_date( )
      ) TO lt_lfa1.
    ENDDO.

    INSERT ZJS_lfa1 FROM TABLE @lt_lfa1.

  ENDMETHOD.


  METHOD generate_sales_orders.

    DATA: lt_vbak TYPE STANDARD TABLE OF ZJS_vbak,
          lt_vbap TYPE STANDARD TABLE OF ZJS_vbap.

    DATA: lt_auart TYPE STANDARD TABLE OF auart.
    lt_auart = VALUE #( ( 'OR' ) ( 'RE' ) ( 'SO' ) ( 'CR' ) ).

    " Get available customers and materials
    SELECT kunnr FROM ZJS_kna1 INTO TABLE @DATA(lt_cust).
    SELECT matnr, meins, matkl FROM zjs_mara INTO TABLE @DATA(lt_mat).

    DATA(lv_cust_count) = lines( lt_cust ).
    DATA(lv_mat_count)  = lines( lt_mat ).

    DO gc_num_so TIMES.
      DATA(lv_so_idx) = sy-index.
      DATA(lv_vbeln) = |SO{ lv_so_idx WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.

      DATA(lv_cust_idx) = get_random_int( iv_min = 1 iv_max = lv_cust_count ).
      READ TABLE lt_cust INTO DATA(ls_cust) INDEX lv_cust_idx.

      DATA(lv_erdat) = get_random_date( ).
      DATA(lv_auart_idx) = get_random_int( iv_min = 1 iv_max = 4 ).
      READ TABLE lt_auart INTO DATA(lv_auart) INDEX lv_auart_idx.

      " Generate 1-5 line items
      DATA(lv_item_count) = get_random_int( iv_min = 1 iv_max = 5 ).
      " DATA(lv_total_net) = CONV dec15_2( 0 ).
      TYPES: ty_amount TYPE p LENGTH 15 DECIMALS 2.
      DATA: lv_total_net TYPE ty_amount VALUE 0.

      DO lv_item_count TIMES.
        DATA(lv_item_idx) = sy-index.
        DATA(lv_mat_idx) = get_random_int( iv_min = 1 iv_max = lv_mat_count ).
        READ TABLE lt_mat INTO DATA(ls_mat) INDEX lv_mat_idx.

        DATA(lv_qty)      = CONV menge_d( get_random_int( iv_min = 1 iv_max = 100 ) ).
        DATA(lv_item_net) = CONV wrbtr( get_random_int( iv_min = 50 iv_max = 10000 ) ).
        lv_total_net = lv_total_net + lv_item_net.

        APPEND VALUE ZJS_vbap(
          client = sy-mandt
          vbeln  = lv_vbeln
          posnr  = |{ lv_item_idx * 10 WIDTH = 6 ALIGN = RIGHT PAD = '0' }|
          matnr  = ls_mat-matnr
          matkl  = ls_mat-matkl
          werks  = COND #( WHEN get_random_int( iv_min = 1 iv_max = 3 ) = 1
                           THEN '1000'
                           WHEN get_random_int( iv_min = 1 iv_max = 3 ) = 2
                           THEN '2000'
                           ELSE '3000' )
          kwmeng = lv_qty
          meins  = ls_mat-meins
          netwr  = lv_item_net
          waerk  = 'EUR'
          erdat  = lv_erdat
        ) TO lt_vbap.
      ENDDO.

      APPEND VALUE ZJS_vbak(
        client = sy-mandt
        vbeln  = lv_vbeln
        auart  = lv_auart
        vkorg  = '1000'
        vtweg  = '10'
        spart  = '00'
        kunnr  = ls_cust-kunnr
        erdat  = lv_erdat
        erzet  = |{ get_random_int( iv_min = 6 iv_max = 18 ) WIDTH = 2
                     ALIGN = RIGHT PAD = '0' }0000|
        netwr  = lv_total_net
        waerk  = 'EUR'
        vbtyp  = 'C'
        ernam  = 'DATAGEN'
      ) TO lt_vbak.
    ENDDO.

    INSERT ZJS_vbak FROM TABLE @lt_vbak.
    INSERT ZJS_vbap FROM TABLE @lt_vbap.

  ENDMETHOD.


  METHOD generate_purchase_orders.

    DATA: lt_ekko TYPE STANDARD TABLE OF ZJS_ekko,
          lt_ekpo TYPE STANDARD TABLE OF ZJS_ekpo.

    " Get available vendors and materials
    SELECT lifnr FROM ZJS_lfa1 INTO TABLE @DATA(lt_vend).
    SELECT matnr, meins FROM zjs_mara INTO TABLE @DATA(lt_mat).

    DATA(lv_vend_count) = lines( lt_vend ).
    DATA(lv_mat_count)  = lines( lt_mat ).

    DO gc_num_po TIMES.
      DATA(lv_po_idx) = sy-index.
      DATA(lv_ebeln) = |PO{ lv_po_idx WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.

      DATA(lv_vend_idx) = get_random_int( iv_min = 1 iv_max = lv_vend_count ).
      READ TABLE lt_vend INTO DATA(ls_vend) INDEX lv_vend_idx.

      DATA(lv_erdat) = get_random_date( ).

      APPEND VALUE ZJS_ekko(
        client = sy-mandt
        ebeln  = lv_ebeln
        bstyp  = 'F'
        bsart  = 'NB'
        lifnr  = ls_vend-lifnr
        ekorg  = '1000'
        ekgrp  = |E0{ get_random_int( iv_min = 1 iv_max = 5 ) }|
        waers  = 'EUR'
        ernam  = 'DATAGEN'
        aedat  = lv_erdat
      ) TO lt_ekko.

      " Generate 1-4 line items
      DATA(lv_item_count) = get_random_int( iv_min = 1 iv_max = 4 ).

      DO lv_item_count TIMES.
        DATA(lv_item_idx) = sy-index.
        DATA(lv_mat_idx) = get_random_int( iv_min = 1 iv_max = lv_mat_count ).
        READ TABLE lt_mat INTO DATA(ls_mat) INDEX lv_mat_idx.

        DATA(lv_qty)   = CONV menge_d( get_random_int( iv_min = 5 iv_max = 500 ) ).
        DATA(lv_price) = CONV wrbtr( get_random_int( iv_min = 10 iv_max = 5000 ) ).

        APPEND VALUE ZJS_ekpo(
          client = sy-mandt
          ebeln  = lv_ebeln
          ebelp  = |{ lv_item_idx * 10 WIDTH = 5 ALIGN = RIGHT PAD = '0' }|
          matnr  = ls_mat-matnr
          werks  = COND #( WHEN get_random_int( iv_min = 1 iv_max = 3 ) = 1
                           THEN '1000'
                           WHEN get_random_int( iv_min = 1 iv_max = 3 ) = 2
                           THEN '2000'
                           ELSE '3000' )
          menge  = lv_qty
          meins  = ls_mat-meins
          netpr  = lv_price
          netwr  = lv_qty * lv_price
          waers  = 'EUR'
        ) TO lt_ekpo.
      ENDDO.
    ENDDO.

    INSERT ZJS_ekko FROM TABLE @lt_ekko.
    INSERT ZJS_ekpo FROM TABLE @lt_ekpo.

  ENDMETHOD.


  METHOD cleanup_all.
    DELETE FROM zjs_vbap.
    DELETE FROM zjs_vbak.
    DELETE FROM zjs_ekpo.
    DELETE FROM zjs_ekko.
    DELETE FROM ZJS_marc .
    DELETE FROM zjs_mara.
    DELETE FROM zjs_kna1.
    DELETE FROM zjs_lfa1.
  ENDMETHOD.


  METHOD get_random_int.
    " Simple pseudo-random using seed
    mv_seed = ( mv_seed * 1103515245 + 12345 ) MOD 2147483647.
    rv_val = iv_min + abs( mv_seed ) MOD ( iv_max - iv_min + 1 ).
  ENDMETHOD.


  METHOD get_random_date.
    DATA(lv_year)  = get_random_int( iv_min = iv_year_from iv_max = iv_year_to ).
    DATA(lv_month) = get_random_int( iv_min = 1 iv_max = 12 ).
    DATA(lv_day)   = get_random_int( iv_min = 1 iv_max = 28 ).
    rv_dat = |{ lv_year }{ lv_month WIDTH = 2 ALIGN = RIGHT PAD = '0' }{
                lv_day WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
  ENDMETHOD.
ENDCLASS.
