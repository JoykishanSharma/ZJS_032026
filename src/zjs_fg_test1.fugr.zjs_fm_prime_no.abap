FUNCTION zjs_fm_prime_no.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_START) TYPE  I DEFAULT 0
*"     VALUE(IV_END) TYPE  I DEFAULT 100
*"     VALUE(IV_COUNT) TYPE  I OPTIONAL
*"  EXPORTING
*"     VALUE(EX_PRIME_LIST) TYPE  STRING
*"----------------------------------------------------------------------
DATA: lv_start     TYPE i,
      lv_end       TYPE i,
      lv_count     TYPE i,
      lt_primes    TYPE TABLE OF i WITH EMPTY KEY,
      lv_num       TYPE i,
      lv_is_prime  TYPE abap_bool,
      lv_div       TYPE i,
      lv_prime_str TYPE string,
      lv_primes_lines TYPE i.

lv_start = iv_start.
lv_end = iv_end.

IF iv_count IS NOT INITIAL.
  lv_count = iv_count.
ENDIF.

IF lv_start < 2.
  lv_start = 2.
ENDIF.

WHILE lv_start <= lv_end.
  lv_num = lv_start.
  lv_is_prime = abap_true.

  IF lv_num = 2.
    " prime
  ELSEIF lv_num MOD 2 = 0.
    lv_is_prime = abap_false.
  ELSE.
    lv_div = 3.
    WHILE lv_div * lv_div <= lv_num.
      IF lv_num MOD lv_div = 0.
        lv_is_prime = abap_false.
        EXIT.
      ENDIF.
      lv_div = lv_div + 2.
    ENDWHILE.
  ENDIF.

  IF lv_is_prime = abap_true.
    APPEND lv_num TO lt_primes.
    lv_primes_lines = LINES( lt_primes ).
    IF lv_count > 0 AND lv_primes_lines >= lv_count.
      EXIT.
    ENDIF.
  ENDIF.

  lv_start = lv_start + 1.
ENDWHILE.

*DESCRIBE TABLE lt_primes LINES lv_primes_lines.
*IF lv_primes_lines = 0.
*  RAISE NO_PRIME_NO_FOUND.
*ENDIF.

LOOP AT lt_primes INTO DATA(lv_p).
  IF lv_prime_str IS INITIAL.
    lv_prime_str = |{ lv_p }|.
  ELSE.
    lv_prime_str = lv_prime_str && ',' && |{ lv_p }|.
  ENDIF.
ENDLOOP.

ex_prime_list = lv_prime_str.


ENDFUNCTION.
