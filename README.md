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


# Install

- `nimble install bcra`
