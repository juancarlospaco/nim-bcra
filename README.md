# BCRA

- [Central Bank of Argentina Gov](https://bcra.gob.ar) API Client with debtor corporations info.


# Use

```nim
import bcra

let cliente = Bcra()
echo cliente.getBajasCheques(fecha = now()) # Bajas nuevas en el sistema
echo cliente.getAltasPadron(fecha = now())  # Altas nuevas en el sistema
echo cliente.getDeudores(fecha = now())     # Deudores
```

- All functions require `fecha` of `DateTime` type, eg `fecha = now() - 2.days`.

Return data type:

```nim
[
  (cuit: int, numeroDeCheque: int, fechaRechazado: DateTime, monto: int, causal: string, fechaLevantamiento: string, ley25326art16inc6: string, ley25326art38inc3: string, cuitJuridico: string, multa: string),
]
```


# Install

- `nimble install bcra`
