# Flow Script README

This README provides detailed information about the `flow.sh` script, which is designed to automate the process of creating and running simulation environments for Verilog, SystemVerilog, and UVM (Universal Verification Methodology) testbenches , following the synthesis flow using ubiquitous synthesis tools as (xilinix vivado / Quartus prime)

## Available Modes

The script supports the following modes:
- `--v`: Typical Verilog testbench (Available)
- `--sv`: Typical SystemVerilog testbench (Coming Soon)
- `--uvm`: Typical UVM environment (Coming Soon)

## Usage

To use the script, the following command str# Project Automation Script - README

## Overview

This script provides a streamlined automation flow for setting up and running simulations, as well as synthesizing designs using the ubiquitous synthesis tools : Xilinix Vivado. It is designed to support different testbench environments, including Verilog, SystemVerilog, and UVM, with future updates to add more functionalities.

## Supported Modes:
- `--v` : Typical Verilog testbench (Available)
- `--sv` : Typical SystemVerilog testbench (Coming Soon)
- `--uvm` : UVM environment (Coming Soon)

## Script Usage:

```bash
./flow.sh [--v|--sv|--uvm] [-q/-c/-s] <Synthesis TCL file> <file_list.txt>
```

## Arguments:
`--v`: Run with a Verilog testbench.

`--sv`: Run with a SystemVerilog testbench.

`--uvm`: Run with a UVM environment.

`-q`: Enable quiet mode, prints the output transcript.

`-c`: Generate a coverage report.

`-s`: Output the synthesis files (up to the bitstream generation).

`<Synthesis TCL file>`: Path to the synthesis TCL script.

`<file_list.txt>`: List of the files to be compiled and simulated.

## Key Features:
### Testbench Compilation and Simulation:

The script automatically generates a .do file for ModelSim/QuestaSim, based on the provided file list and testbench mode.
Supports Verilog testbenches (--v) and soon SystemVerilog (--sv) and UVM (--uvm) environments.

### Coverage Analysis:

The `-c`option allows users to include coverage analysis during simulation in SystemVerilog and UVM environments.
Coverage reports are saved in a .ucdb file and annotated output.

### Synthesis Flow:

The `-s` option triggers synthesis using Vivado in batch mode.
Paths for Vivado batch files are configured within the script, with instructions provided for saving them in ~/.bashrc.
The generated bitstream files can be output as part of the synthesis process.
Vivado Integration:

A shorthand for running Vivado in batch mode is automatically created if not present.
Users are prompted to provide the path to the vivado.bat file for Windows systems.

### Automatic Parsing and Waveform Export:

Future updates may include options to automatically export waveforms and project file hierarchies.
## Notes:
* Ensure your file list (file_list.txt) is formatted correctly, with the DUT and testbench files specified.
* The script currently supports Verilog testbenches (--v) and provides     a framework for extending support to SystemVerilog and UVM.
* For coverage and quiet mode, make sure the relevant flags (-c, -q) are used according to your needs.
## Updates and Future Work:
SystemVerilog & UVM Support: Further updates will focus on parsing SystemVerilog and UVM environments to handle specific features such as interfaces and UVM components.
Waveform Export: A future feature may include an option (-w) to export waveforms as images.
Project Hierarchy Export: Add an option to watch and export the project's file hierarchy.ucture should be followed:
```bash
./flow.sh [--v|--sv|--uvm] [-q/-c/-s] <file_list.txt>
```
### Options

- `--v`: Verilog testbench mode
- `--sv`: SystemVerilog testbench mode
- `--uvm`: UVM environment mode

Additional options:
- `-q`: Prints the output transcript
- `-c`: Prints the coverage report(s)
- `-s`: Outputs the synthesis files (up to the bitstream)

### Example Command

```bash
./flow.sh --v -q -c file_list.txt
```

This command will run the script in Verilog mode, print the output transcript, and generate coverage reports using the file list provided in `file_list.txt`.

## Script Details

The script performs the following tasks:

1. **Create the .do File**: 
    - Identifies the Design Under Test (DUT) from the provided file list.
    - Generates a `.do` file for simulation based on the selected mode and options.
    - Adds compilation and simulation commands to the `.do` file.

2. **Simulation**: 
    - Prompts the user to start the simulation.
    - If the user agrees, the script runs the simulation and parses the output.
    - If `-q` (quiet) option is selected, it runs the simulation in command-line mode.

3. **Coverage and Output Handling**: 
    - If `-c` (coverage) option is selected, it adds coverage-related commands to the `.do` file.
    - Saves and reports coverage data if applicable.

## Script Execution

### Main Function: `crt_do()`

#### Parameters:
- `list file`: The file containing the list of files to compile and simulate.
- `--option`: The mode of the simulation (`--v`, `--sv`, or `--uvm`).
- `cover`: Boolean flag indicating whether to include coverage options.
- `quiet`: Boolean flag indicating whether to run in quiet mode.

#### Process:
1. **DUT Identification**:
    - Extracts the DUT name from the file list.
    - Creates an output file name based on the DUT name.

2. **.do File Management**:
    - Checks for existing `.do` files and prompts the user to keep or overwrite them.
    - Generates a new `.do` file if not keeping the existing one.

3. **Compilation and Simulation Commands**:
    - Adds commands for library creation, compilation, and simulation to the `.do` file.
    - Handles coverage and quiet mode options accordingly.

4. **User Prompt for Simulation**:
    - Prompts the user to start the simulation.
    - Runs the simulation and handles output based on user input and selected options.

### Additional Functions (Coming Soon):
- `crt_synth()`: Function for synthesis-related tasks.

## Project Status

- `--v`: Successful
- `--sv`: Needs parsing for `.sv` DUT in the SystemVerilog interface
- `--uvm`: Needs parsing for UVM objects to add the wave correctly

## Possible Updates

- Add the `-w` option to export the waveform as a `.jpeg` file.

### Example:
```sh
# Open the waveform window and display the signals
view wave
# Run the simulation to the desired point
run -all
# Export the waveform
waveform export -format jpeg -file my_waveform.jpg
