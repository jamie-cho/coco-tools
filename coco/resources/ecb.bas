procedure ecb_at
    param location: integer
    run ecb_locate(land(location, 31), mod(location, 32))


procedure ecb_button
    param button: integer
    param retval: integer
    dim joystk, fire: integer

    if button < 2 then joystk = 0 else joystk = 1 \ endif
    run GFX("Joystk", button, fire, x, y)
    if land(button, 1) = 0 then retval = land(fire, 1) \ endif
    if land(button, 1) = 1 then retval = land(fire, 2) / 2  \ endif


procedure ecb_joystk
    param joystk, joy0x, joy0y, joy1x, joy1y, retval: integer
    dim fire: integer

    if joystk = 0 then
        run GFX("Joystk", 0, fire, joy0x, joy0y)
        run GFX("Joystk", 1, fire, joy1x, joy1y)
    endif

    if joystk = 0 then retval = joy0x \ endif
    if joystk = 1 then retval = joy0y \ endif
    if joystk = 2 then retval = joy1x \ endif
    if joystk = 3 then retval = joy1y \ endif


procedure ecb_cls
    param color: integer
    dim a, b, ii: integer
    dim c: byte
    if color = 1 or color > 8 then
        c = $0c
        put #1, c
        if color > 8 then
            print("MICROSOFT")
        endif
    else
        c = $01
        put #1,c
        run ecb_text_address(a)
        if a <> -1 then
            b = a + 511
            if color = 0 then
                c = 128
            else
                c = 143 + land(7, color - 1) * 16
            endif
            for ii = a to b
                poke ii,c
            next ii
        endif
    endif


procedure ecb_hex
    param v: real
    param str: string
    dim ival: integer
    dim tmp: string

    if v < 0 or v >= 65536 then
        error 52
    endif

    ival = v
    run _ecb_hex_digit(land($f, v / $1000), str)
    run _ecb_hex_digit(land($f, v / $100), tmp)
    str = str + tmp
    run _ecb_hex_digit(land($f, v / $10), tmp)
    str = str + tmp
    run _ecb_hex_digit(land($f, v), tmp)
    str = str + tmp


procedure ecb_inkey
    param c: string

    SHELL("tmode eko=0")
    run INKEY(c)
    SHELL("tmode eko=1")


procedure ecb_locate
    param x, y: integer

    dim tmp_buffer(3): byte
    tmp_buffer(1) = $02
    tmp_buffer(2) = $20 + x
    tmp_buffer(3) = $20 + y
    put #1, tmp_buffer


procedure ecb_point
    param x, y, c0: integer
    dim address, c: integer
    run _ecb_get_point_info(x, y, address, c, c0)
    if address = -1 then
        error 52
    endif
    if c0 > $80 then
        if land(c, c0) <> 0 then
            c0 = 1 + land($7f, c0) / 16
        else
            c0 = 0
        endif
    else
        c0 = -1
    endif


procedure ecb_reset
    param x, y: integer
    dim address, c0, c1: integer
    run _ecb_get_point_info(x, y, address, c1, c0)
    if address = -1 then
        error 52
    endif
    if c0 < $80 then
        c0 = $80
    else
        c0 = land(c0, $8f)
    endif
    poke address, land(c0, $ff - c1)


procedure ecb_set
    param x, y, c: integer
    dim address, c0, c1: integer
    if c < 0 or c > 8 then
        error 52
    endif
    if c = 0 then
        c = 1
    endif
    run _ecb_get_point_info(x, y, address, c1, c0)
    if address = -1 then
        error 52
    endif
    if c0 < $80 then
        c0 = $80
    else
        c0 = land(c0, $8f)
    endif
    poke address, lor(c0, (c - 1) * 16 + c1)


procedure ecb_sound
    param f, d, v:integer
    if f < 0 or f > 255 or d < 0 or d > 255 or v < 0 or v > 63 then
        error 52
    endif
    f = 1.0 / (-2.24219E-05 * f + 0.005961832)
    run gfx2("tone", f, d, v)


procedure ecb_text_address
    param address: integer
    type rregisters = cc, a, b, dp:byte; x, y, u:integer
    dim rregs: rregisters
    dim reqid: byte

    (* getstat ss.alfas *)
    rregs.a = 1
    rregs.b = $1c
    reqid = $8d
    run syscall(reqid, rregs)
    if land(rregs.cc, 1) <> 0 then
        address = -1
    else
        address = rregs.x
    endif


procedure _ecb_hex_digit
    param v: integer
    param s: string
    if v < 10 then
        s = chr$(v + asc("0"))
    else
        s = chr$(v + asc("A"))
    endif


procedure _ecb_get_point_info
    param x, y, address, mask, c0: integer
    if x < 0 or x > 63 or y < 0 or y > 31 then
        error 52
    endif
    run ecb_text_address(address)
    if address = -1 then
        error 52
    endif
    address = address + (y / 2) * 32 + (x / 2)
    mask = 2 ** ((2 * (1 - land(y, 1))) + (1 - land(x, 1)))
    c0 = peek(address)
