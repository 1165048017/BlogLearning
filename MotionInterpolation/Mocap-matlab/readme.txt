This toolbox allows MATLAB to read in and write bvh files and read acclaim files. There are also routines for visualising the files in MATLAB.

Version 0.136 Release Notes
---------------------------

Missing a file for reading the poser data.

Version 0.135 Release Notes
---------------------------

Added visualisation files written by Carl Henrik Ek for the Human Eva data and for Ankur Agarwal's Poser generated silhouette data.

Version 0.134 Release Notes
---------------------------

Bug fix release, a bug in bvh2xyz meant that if a position was included in the bvh skeleton structure for non-root nodes, the xyz positions were computed incorrectly. Thanks to Richard Widgery and Christopher Hulbert for identifying this problem. 

horse.bvh removed due to copyright reasons. To obtain a license for this file, and plenty of other motion capture data of horses, please contact Richard Widgery of Kinetic Impulse.

Version 0.133 Release Notes
---------------------------

Bug fix release, to deal with bugs in mocapResultsCppBvh, thanks to Cedric Vanaken for pointing out the problem.

Version 0.132 Release Notes
---------------------------

Moved tree handling code into NDLUTIL toolbox, version 0.156.

Version 0.131 Release Notes
---------------------------

The axis display for visualising the data gave the limbs on the wrong side (this is a problem of definition of the axis system). It was fixed by placing 

axis ij 

in the skeVisualise.m file. Thanks to Heike Vallery for pointing out this error.

Version 0.13 Release Notes
--------------------------

Added the ability to read motion capture files in the Acclaim format (asf and amc) to facilitate using the CMU Motion Capture database.

Version 0.12 Release Notes
--------------------------

mocapResultsCppBvh now uses the FGPLVM toolbox rather than the GPLVM toolbox.

Version 0.11 Release Notes
--------------------------

There were some missing files in the previous version that have been added in this version.

Version 0.1 Release Notes
-------------------------

First release of the toolbox to coincide with release of C++ GPLVM code.
