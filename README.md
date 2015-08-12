# AbTechAssignment
An assignment from AbTech. Duplicating an existing app which I saw in an iPad. 
Data is from a .json file, and displayed in a UITableView. 

Data consists of several groups, and each one is in a UITableView section. The first row in a section is header, 
and the last one is footer; therefore, UITableView's own header / footer are not used. The very last section is Summary, 
which is not part of data but simply showing each section's footer. 

Note that one section has 2 sub-sections, and each sub has header / footer as well.

Data can be changed and then the entire table is updated immediately.

Each header's top-right and top-left corners are rounded. Likewise, a footer's bottom-right and bottom-left are rounded as well.

iPad only, but both vertical and horizontal orientations are supported.

See 3 .png screen shots to see the output.
