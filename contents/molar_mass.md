# Molar Mass {#sec:molar_mass}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/molar_mass)
(without explanations).

## Problem {#sec:molar_mass_problem}

I remember that back in a day when I was in high-school we used to solve a lot of
activities involving calculations. The essential part of them was to calculate a
molar mass of different molecules.

So here is a task for you. Write a solver that will calculate a molar mass of
different chemical formulas like:

- $CH_{4}$ (methane, natural gas, fossil fuel),
- $H_{2}O$ (water),
- $HCl$ (hydrochloric acid produced in your stomach),
- $CO_{2}$ (carbon dioxide, breath it out),
- $C_{3}H_{8}$ (propane, natural gas, fossil fuel),
- $C_{2}H_{5}OH$ (ethanol, is it time to quit drinking?),
- $(CH_{3})_{2}CO$ (acetone, nail polish remover),
- $NaCl$ (sodium chloride, kitchen salt),
- $CH_{3}COOH$ (acetic acid, vinegar),
- $H_{2}CO_{3}$ (carbonic acid present in your blood),
- $C_{6}H_{12}O_{6}$ (glucose, it gives you energy),
- $C_{11}H_{12}N_{2}O_{2}$ (tryptophan, amino acid, builds proteins),
- $CH_{3}(CH_{2})_{14}COOH$ (palmitic acid, builds fat),
- $C_{34}H_{32}O_{4}N_{4}Fe$ (heme B, located in your red blood cells)
- $Ca_{10}(PO_{4})_{6}(OH)_{2}$ (calcium hydroxyapatite found in your bones)
- $C_{169719}H_{270466}N_{45688}O_{52238}S_{911}$ (titin, a protein that builds your muscles)

Below I paste the formulas and their masses for testing purposes.

```jl
s = """
formulas = ["CH4", "H2O", "HCl", "CO2", "C3H8", "C2H5OH", "(CH3)2CO",
            "NaCl", "CH3COOH", "H2CO3", "C6H12O6", "C11H12N2O2",
            "CH3(CH2)14COOH", "C34H32O4N4Fe", "Ca10(PO4)6(OH)2",
            "C169719H270466N45688O52238S911"]
masses = [16.043, 18.01528, 36.46, 44.01, 44.097, 46.069, 58.08, 58.443,
          60.052, 62.03, 180.156, 204.229, 256.43, 616.487, 1004.61,
          3_816_030]
"""
sc(s)
```

A list of chemical elements and their masses is to be found, e.g. on [this
Wikipedia page](https://en.wikipedia.org/wiki/List_of_chemical_elements#List).

For simplicity, you may assume, that a chemical formula (at least the one at a
high-school level) is composed of ASCII characters (capital/small letters +
digits) and non-nested parentheses.

## Solution {#sec:molar_mass_solution}

The solution goes here.
