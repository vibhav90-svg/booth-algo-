clc;
clear;

// ---------- FUNCTIONS ----------

// Booth Algorithm (simple version for GUI)
function result = booth_calc(m, q)
    result = m * q;
    bin = dec2bin(result);
    result = "Decimal Result: " + string(result) + ascii(10) + ...
             "Binary Result: " + bin;
endfunction

// IEEE Single
function result = ieee_single_calc(x)
    sign = 0;
    if x < 0 then
        sign = 1;
        x = abs(x);
    end

    exponent = floor(log2(x));
    bias = 127;
    exp_bits = dec2bin(exponent + bias, 8);

    mantissa = x / (2^exponent) - 1;
    mantissa_bits = "";
    for i = 1:23
        mantissa = mantissa * 2;
        if mantissa >= 1 then
            mantissa_bits = mantissa_bits + "1";
            mantissa = mantissa - 1;
        else
            mantissa_bits = mantissa_bits + "0";
        end
    end

    result = "Sign: " + string(sign) + ascii(10) + ...
             "Exponent: " + exp_bits + ascii(10) + ...
             "Mantissa: " + mantissa_bits;
endfunction

// IEEE Double
function result = ieee_double_calc(x)
    sign = 0;
    if x < 0 then
        sign = 1;
        x = abs(x);
    end

    exponent = floor(log2(x));
    bias = 1023;
    exp_bits = dec2bin(exponent + bias, 11);

    mantissa = x / (2^exponent) - 1;
    mantissa_bits = "";
    for i = 1:52
        mantissa = mantissa * 2;
        if mantissa >= 1 then
            mantissa_bits = mantissa_bits + "1";
            mantissa = mantissa - 1;
        else
            mantissa_bits = mantissa_bits + "0";
        end
    end

    result = "Sign: " + string(sign) + ascii(10) + ...
             "Exponent: " + exp_bits + ascii(10) + ...
             "Mantissa: " + mantissa_bits;
endfunction

// ---------- CALLBACK FUNCTION ----------
function calculate_callback()
    op = get(operation, "value");

    if op == 1 then
        m = evstr(get(num1, "string"));
        q = evstr(get(num2, "string"));

        if m == [] | q == [] then
            set(output, "string", "Enter both numbers!");
            return;
        end

        res = booth_calc(m, q);

    elseif op == 2 then
        x = evstr(get(decimalNum, "string"));
        res = ieee_single_calc(x);

    else
        x = evstr(get(decimalNum, "string"));
        res = ieee_double_calc(x);
    end

    set(output, "string", res);
endfunction

// ---------- TOGGLE INPUTS ----------
function toggle_callback()
    op = get(operation, "value");

    if op == 1 then
        set(num1, "visible", "on");
        set(num2, "visible", "on");
        set(decimalNum, "visible", "off");
    else
        set(num1, "visible", "off");
        set(num2, "visible", "off");
        set(decimalNum, "visible", "on");
    end
endfunction

// ---------- GUI DESIGN ----------
f = figure("position", [300 200 500 400], "backgroundcolor", [0.8 0.8 0.8]);

uicontrol(f, "style", "text", "string", "Number Conversion & Booth Algorithm", ...
          "position", [50 350 400 30], "fontsize", 14);

// Dropdown
operation = uicontrol(f, "style", "popupmenu", ...
    "string", ["Booth"; "IEEE Single"; "IEEE Double"], ...
    "position", [150 300 200 30], ...
    "callback", "toggle_callback()");

// Inputs
num1 = uicontrol(f, "style", "edit", "position", [150 250 200 30], ...
    "string", "", "tooltipstring", "Enter first number");

num2 = uicontrol(f, "style", "edit", "position", [150 210 200 30], ...
    "string", "", "tooltipstring", "Enter second number");

decimalNum = uicontrol(f, "style", "edit", "position", [150 250 200 30], ...
    "string", "", "visible", "off");

// Button
uicontrol(f, "style", "pushbutton", "string", "Calculate", ...
    "position", [180 160 120 40], ...
    "callback", "calculate_callback()");

// Output
output = uicontrol(f, "style", "text", ...
    "position", [50 50 400 100], ...
    "backgroundcolor", [1 1 1], ...
    "string", "Result will appear here");

// Initialize
toggle_callback();
