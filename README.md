# Truss Bridge Dynamics – Yearwork (Dynamics of Mechanical Systems)

Analisi dinamica di un ponte ferroviario a travatura reticolare a campata unica
(hinge in O1, carrello in O2), svolta per il corso *Dynamics of Mechanical
Systems* (proff. S. Bruni, G. Bucca, eng. S. Alfi, S. Zuin).

Il modello FEM è costruito e risolto tramite il software didattico
**`dmb_fem2`** (fornito dal corso, non incluso in questo repo — vedi
[Software esterno](#software-esterno-non-incluso)). Gli script MATLAB in
`src/` **non ricostruiscono il solutore**: caricano le matrici strutturali
già assemblate ed esportate da `dmb_fem2` (`*_mkr.mat`) e le usano per le
analisi richieste dai punti della consegna che il software non copre
direttamente (risposta sismica, passaggio di un treno di carichi).

## Struttura del repository

```
bridge-dynamics-project/
├── docs/
│   ├── assignment.pdf                  # Testo della consegna (6 punti richiesti)
│   ├── dmb_fem2_user_manual.pdf        # Manuale utente del software dmb_fem2
│   └── reference_example_yearwork.pdf  # Yearwork di esempio (E. Castelli) preso a riferimento
├── input/
│   ├── bridge.inp                      # Modello FEM del ponte (nodi, beam, damping) per dmb_fem2
│   └── point_6_modified_structure.inp  # Variante strutturale per il punto 6 (riduzione accelerazione in B)
├── data/
│   ├── bridge_mkr.mat                  # Matrici M, K, R (=C) e idb esportate da dmb_fem2 per bridge.inp
│   └── seismic_displ.txt               # Storia temporale degli spostamenti sismici imposti in O1, O2
├── src/
│   ├── point4_seismic_response.m           # Punto 4: risposta sismica (FRF, spettri, storie temporali A/B)
│   ├── point4_seismic_input_spectrum.m     # Punto 4: spettro dei soli input sismici y_O1, y_O2 (script alternativo)
│   ├── point5_train_resonance.m            # Punto 5: forzante da treno di carichi mobili, verifica di risonanza
│   └── exploratory_manual_matrix_assembly.m# Bozza esplorativa: assemblaggio manuale delle matrici globali
│                                            # (non usata nella soluzione finale, superata dall'export di dmb_fem2)
└── results/
    └── figures/                        # Output grafici generati dagli script (non versionati, vedi .gitignore)
```

## Punti della consegna e dove trovarli

| Punto | Descrizione | Dove |
|---|---|---|
| 1 | Modello FEM valido 0–30 Hz (lunghezza massima elementi) | `input/bridge.inp` + GUI `dmb_fem2` |
| 2 | Frequenze proprie e modi di vibrare 0–30 Hz | GUI `dmb_fem2` (Frequencies domain analysis) |
| 3 | FRF spostamento/accelerazione nei punti A, B | GUI `dmb_fem2` (Frequency response) |
| 4 | Risposta sismica (spettri, storie temporali A/B) | `src/point4_seismic_response.m`, `src/point4_seismic_input_spectrum.m` |
| 5 | Risonanza da treno di carichi mobili (velocità V) | `src/point5_train_resonance.m` |
| 6 | Modifica strutturale (−15% accelerazione in B, +5% massa max) | `input/point_6_modified_structure.inp` + GUI `dmb_fem2` |

## Software esterno (non incluso)

Gli script assumono `dmb_fem2.m` e le relative funzioni (fornite dal corso)
presenti nel *path* di MATLAB. Il software si avvia digitando `dmb_fem2` da
Command Window; da lì si carica `input/bridge.inp` (menu *File → Load
structure*) e si esportano le matrici strutturali (*Export → Structural
matrices*), generando il file `*_mkr.mat` usato dagli script in `src/`.
Vedi `docs/dmb_fem2_user_manual.pdf` per il dettaglio dell'interfaccia e del
formato `*.inp`.

## Come eseguire

1. Aggiungere `dmb_fem2` al path di MATLAB e generare/verificare
   `data/bridge_mkr.mat` a partire da `input/bridge.inp` (oppure usare
   direttamente il file già incluso).
2. Eseguire gli script in `src/` dalla cartella `data/` (o aggiornare i
   percorsi `load(...)` in cima a ciascuno script) per riprodurre le figure
   dei punti 4 e 5.
3. Per il punto 6, caricare `input/point_6_modified_structure.inp` nella GUI
   di `dmb_fem2` e ripetere l'analisi di frequenza response sul punto B.

## Note

- `exploratory_manual_matrix_assembly.m` è un tentativo preliminare di
  ricostruire manualmente le matrici globali (E_k, assemblaggio per
  sommatoria) partendo dal file `.inp`; è mantenuto per documentare il
  percorso di lavoro ma **non è necessario** perché `dmb_fem2` esporta già
  le matrici assemblate complete (F+C) in `bridge_mkr.mat`.
- Gli indici di nodo A/B usati negli script (`nodeA = 21`, `nodeB = 12`)
  fanno riferimento ai gradi di libertà (idb) del modello `bridge.inp`
  esportato da `dmb_fem2` — vedere `docs/dmb_fem2_user_manual.pdf` §5 per la
  spiegazione della matrice `idb`.
