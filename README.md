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

**Arguments**

- All functions require `fecha` of `DateTime` type, eg `fecha = now() - 2.days`.
- It is not documented when the data for current day becomes available, if you get errors use `fecha = now() - 1.days` for yesterdays data.

**Return**

- Return data type is a list of tuples:

```nim
[
  (cuit: int, numeroDeCheque: int, fechaRechazado: DateTime, monto: int, causal: string, fechaLevantamiento: string, ley25326art16inc6: string, ley25326art38inc3: string, cuitJuridico: string, multa: string),
]
```


# SSL

- Compile with `-d:ssl` to use HTTPS and SSL. It works with and without SSL.


# Install

- `nimble install bcra`
