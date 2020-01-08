import times, strutils, httpclient, os, zip/zipfiles

type Bcra* = HttpClient ## BCRA API Client http://bcra.gob.ar/Pdfs/Texord/t-ceninf.pdf

template getLink*(this: Bcra, fecha: DateTime): string =
  "http" & static(when defined(ssl): "s" else: "" & "://www.bcra.gov.ar/zips/cheques/") & format(fecha, "yyyyMMdd") & ".zip"

proc downloadFile*(this: Bcra, path: string, fecha: DateTime, unzip = true): string =
  result = path / format(fecha, "yyyyMMdd") & ".zip"
  let client = newHttpClient()
  client.downloadFile(this.getLink(fecha), result)
  if unzip:
    var z: ZipArchive
    doAssert z.open(result), "Error extracting ZIP; Corrupted ZIP or API error."
    z.extractAll(path)
    z.close()

proc getBajasCheques*(this: Bcra, fecha: DateTime): seq[tuple[numeroDeCheque: Positive]] =
  let f = getTempDir() / "cheques" / "ba" & format(fecha, "yyMMdd") & ".txt"
  if not existsFile(f): echo this.downloadFile(getTempDir(), fecha)
  for line in lines(f): result.add (numeroDeCheque: line.strip.parseInt.Positive)

proc getAltasPadron*(this: Bcra, fecha: DateTime): seq[tuple[cuit: Positive, denominacion: string]] =
  let f = getTempDir() / "cheques" / "pa" & format(fecha, "yyMMdd") & ".txt"
  if not existsFile(f): echo this.downloadFile(getTempDir(), fecha)
  for line in lines(f): result.add (cuit: line.strip[0..10].strip.parseInt.Positive, denominacion: line.strip[11..^1])

proc getDeudores*(this: Bcra, fecha: DateTime):
  seq[tuple[cuit, numeroDeCheque: Positive, fechaRechazado: DateTime, monto: Positive, causal, fechaLevantamiento, ley25326art16inc6, ley25326art38inc3, cuitJuridico, multa: string]] =
  let f = getTempDir() / "cheques" / "al" & format(fecha, "yyMMdd") & ".txt"
  if not existsFile(f): echo this.downloadFile(getTempDir(), fecha)
  for line in lines(f):
    var x = line.strip
    result.add (cuit:               x[0..10].strip.parseInt.Positive,
                numeroDeCheque:     x[11..20].strip.parseInt.Positive,
                fechaRechazado:     parse(x[21..28].strip, "yyyyMMdd"),
                monto:              x[29..41].strip.parseInt.Positive,
                causal:             if x[44] == '2': "Sin Fondos" else: "Vicios Formales",
                fechaLevantamiento: x[45..52].strip,
                ley25326art16inc6:  if x[53] == 'E': "En Revision" else: "Fin Revision",
                ley25326art38inc3:  if x[54] == 'J': "En Proceso Judicial" else: "Fin Proceso Judicial",
                cuitJuridico:       x[55..65].strip,
                multa:              x[66..^1].strip)


when isMainModule:
  let cliente = Bcra()
  echo cliente.getLink(fecha = now() - 2.days)
  echo cliente.downloadFile(path = getTempDir(), fecha = now() - 2.days)
  echo cliente.getBajasCheques(fecha = now() - 2.days)
  echo cliente.getAltasPadron(fecha = now() - 2.days)
  echo cliente.getDeudores(fecha = now() - 2.days)
