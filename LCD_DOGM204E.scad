/*
 * LCD_DOGM204E.scad
 *
 * Static, colored 3D model for the DOGM204E-W LCD panel
 *
 * Sorry I forgot to make this fully parametric :P
 */

// Test model
LCD_DOGM204E();

module LCD_DOGM204E() {
  
  // Object colors
  COLOR_GLASS     = [ 1.00, 1.00, 1.00, 0.15 ];
  COLOR_POLARIZER = [ 0.00, 0.00, 0.00, 0.15 ];
  COLOR_METAL     = [ 0.75, 0.75, 0.75, 1.00 ];
  COLOR_PLASTIC   = [ 1.00, 1.00, 1.00, 1.00 ];
  
  // Pin locations
  PINS = [
    for (i = [-26.67 : 2.54 : -20.22])
    [ i, -18.9, 0 ],
    for (i = [20.22 : 2.54 : 26.67])
    [ i, -18.9, 0 ],
    for (i = [26.67 : -2.54 : -26.67])
    [ i, 18.9, 180 ]
  ];
  
  union() {
    
    // Front polarizer film
    color(COLOR_POLARIZER)
    translate([0, 0, 1.049])
    cube([63, 26, 0.1], center = true);
    
    // Front glass pane
    color(COLOR_GLASS)
    translate([0, -0.8, 0.499])
    cube([66, 29, 1], center = true);
    
    // Rear glass pane
    color(COLOR_GLASS)
    translate([0, 0, -0.5])
    cube([66, 37.8, 1], center = true);
    
    // Backlight substrate
    color(COLOR_PLASTIC)
    translate([0, 0, -4.3])
    cube([66, 40.2, 0.6], center = true);
    
    // Backlight LED box
    color(COLOR_METAL)
    translate([0, -0.8, -2.5])
    cube([66, 29, 3], center = true);
    
    // Pins
    color(COLOR_METAL)
    for (pin = PINS)
    translate([pin[0], pin[1]])
    rotate([0, 0, pin[2]]) {
      
      // Pad on top of rear glass pane
      translate([0, 0.95, 0.25])
      cube([1.8, 2.5, 0.5], center = true);
      
      // Pin
      translate([0, -0.15, -4])
      cube([0.5, 0.3, 8], center = true);
      
      // Pad on backlight layer
      translate([0, -0.15, -4.3])
      cylinder(0.8, d=1.8, $fn = 20, center = true);
      
    }
  }
}
