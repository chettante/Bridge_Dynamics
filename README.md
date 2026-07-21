# Truss Bridge Dynamics – Yearwork (Dynamics of Mechanical Systems)

Dynamic analysis of a single-span railway truss bridge (hinged at O1, roller support at O2), carried out for the course *Dynamics of Mechanical Systems* (Prof. S. Bruni, Prof. G. Bucca, Eng. S. Alfi, Eng. S. Zuin).

The FEM model is constructed and solved using the educational software **`dmb_fem2`** (provided by the course, not included in this repo — see [External Software](#external-software-not-included)). The MATLAB scripts in `src/` **do not rebuild the solver**: they load the pre-assembled structural matrices exported by `dmb_fem2` (`*_mkr.mat`) and use them to perform the specific analyses required by the assignment points that the software does not natively support (seismic response, passage of a moving train load).

## Repository Structure

```
bridge-dynamics-project/
├── docs/
│   ├── assignment.pdf                # Assignment specification (6 required points)
│   ├── dmb_fem2_user_manual.pdf        # User manual for the dmb_fem2 software
│   └── reference_example_yearwork.pdf  # Reference example yearwork (E. Castelli) used as a baseline
├── input/
│   ├── bridge.inp                    # FEM model of the bridge (nodes, beams, damping) for dmb_fem2
│   └── point_6_modified_structure.inp  # Structural variant for point 6 (reduction of acceleration at B)
├── data/
│   ├── bridge_mkr.mat                # M, K, R (=C) matrices and idb exported by dmb_fem2 for bridge.inp
│   └── seismic_displ.txt               # Time history of imposed seismic displacements at O1, O2
├── src/
│   ├── point4_seismic_response.m           # Point 4: seismic response (FRFs, spectra, time histories at A/B)
│   ├── point4_seismic_input_spectrum.m     # Point 4: spectrum of input seismic displacements y_O1, y_O2 only (alternative script)
│   ├── point5_train_resonance.m            # Point 5: forcing function from moving train loads, resonance check
│   └── exploratory_manual_matrix_assembly.m# Exploratory draft: manual assembly of global matrices
│                                           # (unused in the final solution, superseded by dmb_fem2 export)

```

## Assignment Points and Locations

| Point | Description | Where to find it |
|---|---|---|
| 1 | Valid FEM model for 0–30 Hz (maximum element length) | `input/bridge.inp` + `dmb_fem2` GUI |
| 2 | Natural frequencies and mode shapes (0–30 Hz) | `dmb_fem2` GUI (Frequency domain analysis) |
| 3 | Displacement/acceleration FRFs at points A, B | `dmb_fem2` GUI (Frequency response) |
| 4 | Seismic response (spectra, time histories at A/B) | `src/point4_seismic_response.m`, `src/point4_seismic_input_spectrum.m` |
| 5 | Resonance from moving train load (velocity V) | `src/point5_train_resonance.m` |
| 6 | Structural modification (−15% acceleration at B, +5% max mass) | `input/point_6_modified_structure.inp` + `dmb_fem2` GUI |

## External Software (Not Included)

The scripts assume that `dmb_fem2.m` and its associated functions (provided by the course) are present in the MATLAB path. The software is launched by typing `dmb_fem2` into the Command Window; from there, you load `input/bridge.inp` (*File → Load structure*) and export the structural matrices (*Export → Structural matrices*), generating the `*_mkr.mat` file used by the scripts in `src/`. Refer to `docs/dmb_fem2_user_manual.pdf` for details regarding the user interface and `.inp` file format.

## How to Run

1. Add `dmb_fem2` to the MATLAB path and generate/verify `data/bridge_mkr.mat` starting from `input/bridge.inp` (or use the pre-included file directly).
2. Run the scripts in `src/` from the `data/` directory (or update the file paths in `load(...)` at the top of each script) to reproduce the plots for points 4 and 5.
3. For point 6, load `input/point_6_modified_structure.inp` into the `dmb_fem2` GUI and repeat the frequency response analysis for node B.

## Notes

- `exploratory_manual_matrix_assembly.m` is a preliminary attempt to manually reconstruct the global matrices ($E_k$, summation assembly) directly from the `.inp` file. It is retained strictly to document the workflow, but **is not required** since `dmb_fem2` directly exports the fully assembled constrained/unconstrained matrices in `bridge_mkr.mat`.
- The node indices for A/B used in the scripts (`nodeA = 21`, `nodeB = 12`) refer to the degrees of freedom (`idb`) of the `bridge.inp` model exported by `dmb_fem2` — see `docs/dmb_fem2_user_manual.pdf` §5 for an explanation of the `idb` matrix mapping.
