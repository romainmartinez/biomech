**Warning**: biomech is currently under development and not ready for public release.
# ToC

# Introduction
biomech is a Matlab toolbox which provides a complete workflow from biomechanical raw data to publication ready results.

The first intent was to keep a structured collection of codes during my Ph.D. and leave usables codes to future Ph.D. students in my lab.

# Warnings
Tested under Matlab 2017a version.
biomech is designed to work with `c3d` files. Support for `csv` is planned.
Please, make sure to install the dependencies.

# Dependencies
- btk [link]
- gui layout [link]
- S2M_rbdl [link]

# Installation
Download the github repo [link], start Matlab and make the biomech folder your working directory.

# Workflow
## Tree

## Pre-processing
### Configuration files
The first step of a bmch project is the creation of a project folder with the option `[1] - create new bmch project` in the `preprocessing` category.
You have to choose an empty folder to initialize a bmch project. This option will create three folders:

- `conf`: where the configuration files are stored
- `inputs`: folder containing data folders
- `ouputs`: folder containing elaborated data

Once created, you have to fill three files in the `conf` folder :

- `emg.csv`: fill with the emg id and publication names
- `markers.csv`: fill with markers' name
- `participants.csv`: fill with your participants' informations
- `trials.csv`: fill with the different types of trial recorded (*e.g.* SCoRE, MVC, trials)

Once filled, you can run `[2] - load existing bmch project into cache`. This will load the configuration files previously filled in the 'cache' folder, which is loaded each time you run the toolbox.

### Import files
Choose between the different types of data (emg, markers, force). One challenge related to c3d files concern the channels assignement. Particularly if you chose a different channel name within your trials or participants. To overcome that, bmch toolbox take care of the channel assignement.
You just have to assign the c3d channels to your configurations files once for each participant in an integrated GUI.
If the channel name doesn't match for one trial, the GUI will pop again.

The corresponding data will then be exported in `mat` files:

| Data      | Dimensions | Description           |
|-----------|------------|-----------------------|
| emg       | 2          | frames*muscle         |
| force     | 2          | frames*channel        |
| markers   | 4          | maker*data*axe*frames |
| kinematic | 3          | dof*data*frames       |

### Model construction
*see S2M_rbdl library: `shoulder_2.m`*

### Kinematic reconstruction
*see S2M_rbdl library: `kinreconstout.m`*

## Processing

### EMG

#### MVC
**article**

### Kinematic

#### Scapulo-humeral rhythm

#### Joint contributions

##### Height

##### Velocity

### Modelling

## Statistics

### Statistical Parametric Mapping

## Plot


# Contributors
Romain Martinez, Ph.D. candidate at S2M in Université de Montréal.

# Acknowledgements
biomech used code from:
- btk [link]
- gui layout toolbox [link]
- S2M_rbdl
- gramm [link]
