/*
 * Custom keyboard case for Xiaomi Pad 6 (pipa)
 * Copyright (c) 2026 vipoll <vipollmail@gmail.com>
 *
 * This source describes Open Hardware and is licensed under the
 * CERN-OHL-W v2.
 *
 * You may redistribute and modify this source and make products
 * using it under the terms of the CERN-OHL-W v2
 * (https://ohwr.org/cern_ohl_w_v2.txt).
 *
 * This source is distributed WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY
 * QUALITY AND FITNESS FOR A PARTICULAR PURPOSE. Please see
 * the CERN-OHL-W v2 for applicable conditions.
 *
 * Source location: https://github.com/vipaoL/xiaomi-pipa-custom-keyboard/blob/master/pipa-kb.scad
 */

use <roundedcube.scad>

// top/bottom/all (print the parts *indivually*, use "all" for demo)
PART = "all";

// make sure you can print the joints properly
TEST1 = false;

// print the skeleton to make sure that all sizes are correct
// PLEASE PRINT AND TRY THIS BEFORE PRINTING THE FULL MODEL
TEST2 = false;

w = 253;
tablet_h = 165;
tablet_t = 7;

r = 10;
t = 5;
e = 0.1;

magnet_shape = "round"; // round/rect
magnet_w = 3;
// magnet_d = ; // for rect magnets
magnet_h = 1;

// keyboard from Asus Eee PC 701
kb_w = 212;
kb_d = 81;
kb_h = 4.5;
kb_v_gap = 1;
kb_cut_h = kb_h + kb_v_gap * 2;

kb_top_notch_w = 6;
kb_top_notch_h = 1;
kb_top_notch_d = 2;
kb_top_notches = [
    26,
    96,
    kb_w - 37,
];

kb_bottom_tab_w = 10;
kb_bottom_tab_h = 1;
kb_bottom_tab_d = 2;
kb_bottom_tabs = [
    25,
    116,
    kb_w - 25,
];

kb_flex_w = 30;
kb_flex_pos = 65;
kb_flex_space_h = 3;

// "blue pill" board, but with STM32L051C* and 1.8V LDO
mcu_board = [60, 23, 8];

top_h = 105;

cam_x = 23 - w / 2;
cam_y = -23 + top_h / 2;
cam_w = 35;
cam_h = 35;
cam_r = 7;
cam_e = e * 6;

cam_left_x = cam_x - (cam_w + 1) / 2;
cam_right_x = cam_x + (cam_w + 1) / 2;

cam_top_y = cam_y + (cam_h + 1) / 2;
cam_bott_y = cam_y - (cam_h + 1) / 2;

magnets = [
    [cam_x, cam_y], // fake magnet for TEST2

    // under the camera
    [cam_right_x - 4.5, cam_bott_y - 5],
    [cam_right_x - 4.5, cam_bott_y - 5 - 6],
    [cam_right_x - 4.5, cam_bott_y - 5 - 6 - 6],

    // under the camera, near the side
    [cam_left_x + 6, cam_bott_y - 31],
    [cam_left_x + 6 + 4, cam_bott_y - 31],
    [cam_left_x + 6, cam_bott_y - 31 - 4],
    [cam_left_x + 6 + 4, cam_bott_y - 31 - 4],

    // near the camera side
    [cam_x + 25, cam_y + 11],
    [cam_x + 25, cam_y + 11 - 5],
    [cam_x + 25 + 5, cam_y + 11],
    [cam_x + 25 + 5, cam_y + 11 - 5],

    // hall sensor that detects the keyboard
    [-23, 45],

    // at the side of pogo pins (to the center)
    [88.5, 39.5],
    [88.5, 39.5 + 5.5],
    [88.5 + 5.5, 39.5],
    [88.5 + 5.5, 39.5 + 5.5],

    // above the pins
    [101, 45],
    [101 + 5, 45],
    [101 + 5 + 5, 45],

    // at the side of pogo pins (to the side of the tablet)
    [118.5, 39],
    [118.5, 39 - 4],
    [118.5 + 4, 39],
    [118.5 + 4, 39 - 4],

    // near type-c, under the pogo pins
    [93.5, -22.5],
    [93.5, -22.5 + 5],
    [93.5 + 5, -22.5],
    [93.5 + 5, -22.5 + 5],
];

pogo_pins = [
    [106.5 - 5.5, 38.5],
    [106.5, 38.5], // 106.3?
    [106.5 + 5.5, 38.5],
];

pogo_base_w = 2;
pogo_base_h = 0.2;
pogo_w = 1.5;
pogo_h = 2;
pogo_pins_pos = [106.5, 38.5];
pogo_board_size = [18, 10, 1.5];
pogo_board_hole_step = 2.54;
pogo_board_offset = [0, -pogo_board_hole_step / 2];
pogo_module_size = [
    pogo_board_size.x,
    pogo_board_size.y,
    e*2 + pogo_board_size.z + pogo_h
];

joint_count = 99;
joint_d = t * 3 / 2;
joint_w = w / joint_count;

center_part_h = 60 + t;
center_part_pos = [0, -top_h / 2 - center_part_h / 2, 0];
center_part_top_joint_pos = [0, center_part_h / 2, 0];
center_part_bottom_joint_pos = [0, -center_part_h / 2, 0];

connection_part_h = tablet_t + t + e * 2;
connection_part_pos = [0, -top_h / 2 - center_part_h - connection_part_h / 2, 0];
connection_part_top_joint_pos = [0, connection_part_h / 2, 0];
connection_part_bottom_joint_pos = [0, -connection_part_h / 2, 0];

bottom_part_l = t + tablet_h;
bottom_part_t = 9;

bottom_part_offset_y = -top_h / 2 - center_part_h - connection_part_h - bottom_part_l / 2;
bottom_part_offset_z = t / 2 - bottom_part_t / 2;
bottom_part_offset = PART != "all" ? [0, 0, 0] : [0, bottom_part_offset_y, bottom_part_offset_z];

bottom_part_joint_pos = [0, bottom_part_l / 2, bottom_part_t / 2 - t / 2];

bottom_part_margin = 10;

kb_cut_corner_pos = [-w / 2 + bottom_part_margin, -bottom_part_l / 2 + bottom_part_margin, bottom_part_t/2];

kb_pos = kb_cut_corner_pos + [kb_w / 2, kb_d / 2, -kb_cut_h / 2];

kb_wires_channel = [kb_flex_w, 5, 10];
kb_wires_channel_pos = kb_cut_corner_pos + [kb_flex_pos, kb_d + kb_wires_channel.y / 2, -kb_v_gap - kb_h - kb_flex_space_h + kb_wires_channel.z / 2];

mcu_board_pos = [kb_wires_channel_pos.x, kb_wires_channel_pos.y + kb_wires_channel.y / 2 + mcu_board.y / 2, kb_cut_corner_pos.z - mcu_board.z / 2];

tablet_wires = [2, bottom_part_l / 2 - joint_d / 2 - (mcu_board_pos.y + mcu_board.y / 2), bottom_part_t / 2];
tablet_wires_pos = [mcu_board_pos.x, mcu_board_pos.y + mcu_board.y / 2 + tablet_wires.y / 2, kb_cut_corner_pos.z - tablet_wires.z / 2];

tablet_wires_space_in_joint = [joint_w * 5, joint_d, bottom_part_t];
tablet_wires_space_in_joint_pos = [floor(tablet_wires_pos.x / joint_w + 1) * joint_w, bottom_part_joint_pos.y, 0];

connection_part_pos_2d = [connection_part_pos.x, connection_part_pos.y];
center_part_pos_2d = [center_part_pos.x, center_part_pos.y];

wire_groove_points = [
    [tablet_wires_space_in_joint_pos.x, connection_part_bottom_joint_pos.y] + connection_part_pos_2d,
    [tablet_wires_space_in_joint_pos.x, (connection_part_bottom_joint_pos.y + connection_part_top_joint_pos.y) / 2] + connection_part_pos_2d,
    [tablet_wires_space_in_joint_pos.x, connection_part_top_joint_pos.y] + connection_part_pos_2d,
    [floor((tablet_wires_space_in_joint_pos.x + w / 3) / joint_w + 1) * joint_w, center_part_top_joint_pos.y] + center_part_pos_2d,
];

module magnet(pos) {
    translate([pos.x, pos.y, t / 2 - magnet_h / 2 - e*5]) {
        if (magnet_shape == "round") {
            cylinder(d = magnet_w + e*2, h = magnet_h + e*11, center=true);
        } else if (magnet_shape == "rect") {
            cube([magnet_w + e*2, magnet_d + e*2, magnet_h + e*11], center=true);
        } else {
            assert(false, concat("unknown magnet shape: ", magnet_shape));
        }
    }
}

module cut_magnets() {
    for (m = magnets) {
        magnet(m);
    }
}

module pogo_pin(pos) {
    translate(pos) {
        cylinder(d=pogo_board_hole_step + e*2, h=t + e*2, center=true);
    }
    *translate([pos.x, pos.y, t / 2 - pogo_h / 2 - e]) {
        cylinder(d=pogo_w + e*2, h=pogo_h + e*3, center=true);
        translate([0, 0, -pogo_h/2 + pogo_base_h/2]) cylinder(d=pogo_base_w + e*2, h=pogo_base_h + e*2, center=true);
    }
}

module cut_pogo_pin_module() {
    translate(pogo_pins_pos + pogo_board_offset) {
        translate([0, 0, t / 2 - pogo_module_size.z / 2 + e/10]) {
            cube(pogo_module_size, center=true);
        }
    }
}

module cut_pogo_pins() {
    for (p = pogo_pins) {
        pogo_pin(p);
    }
}

module pogo_board_spikes() {
    step = pogo_board_hole_step;
    translate(pogo_pins_pos) {
        left = floor((pogo_board_size.x / 2 + pogo_board_offset.x) / step);
        right = floor((pogo_board_size.x / 2 - pogo_board_offset.x) / step);
        top = floor((pogo_board_size.y / 2 - pogo_board_offset.y) / step);
        bottom = floor((pogo_board_size.y / 2 + pogo_board_offset.y) / step);

        x_count = left + 1 + right;
        y_count = top + 1 + bottom;
        for (i = [0 : x_count - 1]) {
            for (j = [0 : y_count - 1]) {
                x = -left * step
                    + i * step;
                y = -top * step
                    + j * step;
                translate([x, y, t/2-pogo_module_size.z]) cylinder(d=1, h=t/4);
            }
        }
    }
}

module cut_pogo_pins_cover() {
    for (p = pogo_pins) {
        pogo_pin(p);
    }
    translate(pogo_pins_pos) cube([pogo_board_size.x, pogo_board_size.y, e*2 + pogo_board_size.z + pogo_h], center=true);
}

module cam_hole() {
    roundedcube([cam_w + cam_e * 2, cam_h + cam_e * 2, t + e], center=true, radius=cam_r + cam_e, apply_to="z");
}

module cut_for_joint(i) {
    difference() {
        translate([0, i == 0 ? t/3 : -t/3, 0]) cube([w + e, joint_d + e, t + e], center=true);
        translate([0, i == 0 ? t : -t]) rotate([0, 90, 0]) scale([1, 0.75, 1]) cylinder(d = t + e, h = w + e, center = true);
    }
}

module joint_axis() {
    rotate([0, 90, 0]) cylinder(d = t/2 - e * 2, h = w, center = true);
}

module joint_axis_hole() {
    rotate([0, 90, 0]) cylinder(d = t/2 + e * 10, h = w + e, center = true);
}

module joint(i, axis_or_hole, ext_l, direction) {
    axis_or_hole = axis_or_hole != undef ? axis_or_hole : (1 - i);
    ext_l = ext_l != undef ? ext_l : t;
    direction = direction != undef ? direction : i;

    difference() {
        translate([- w / 2 + joint_w / 2, 0, 0])
        for (j = [i : 2 : joint_count - 1]) {
            translate([j * joint_w, 0, 0]) {
                rotate([0, 90, 0]) cylinder(d = t, h = joint_w - e * 4, center = true);
                translate([0, direction == 0 ? ext_l/2 : -ext_l/2, 0]) cube([joint_w - e * 4, ext_l, t], center = true);
            }
        }

        if (axis_or_hole == 0) {
            joint_axis_hole();
        }
    }
    if (axis_or_hole == 1) {
        joint_axis();
    }
}

module top_part() {
    joint_pos = [0, -top_h / 2, 0];
    difference() {
        union() {
            roundedcube([w, top_h, t], center=true, radius=r, apply_to="z");

            // we don't need rounded corners at the joint side
            translate([0, -top_h / 4, 0]) cube([w, top_h / 2, t], center=true);
        }

        // camera cutout
        translate([cam_x, cam_y, 0]) cam_hole();
        //translate([cam_x, cam_y - cam_h - 3, 0]) cam_hole();
        //translate([cam_x, cam_y - cam_h*3/2 - 3, 0]) cam_hole();

        // joint will be here
        translate(joint_pos) cut_for_joint(0);
    }
    // joint
    translate(joint_pos) joint(0);
}

module center_part() {
    difference() {
        cube([w, center_part_h, t], center=true);

        // top joint will be here
        translate(center_part_top_joint_pos) cut_for_joint(1);
        // bottom joint will be here
        translate(center_part_bottom_joint_pos) cut_for_joint(0);

        if (TEST1) {
            translate([cam_x, 8, 0]) cam_hole();
            translate([cam_x, -8, 0]) cam_hole();
        }
    }
    // top joint
    translate(center_part_top_joint_pos) joint(1);
    //bottom joint
    translate(center_part_bottom_joint_pos) joint(0);
}

module connection_part() {
    difference() {
        cube([w, connection_part_h, t], center=true);

        // top joint will be here
        translate(connection_part_top_joint_pos) cut_for_joint(1);
        // bottom joint will be here
        translate(connection_part_bottom_joint_pos) cut_for_joint(0);
    }
    // top joint
    translate(connection_part_top_joint_pos) joint(1);//, ext_l = connection_part_h - t / 2 - e * 10);
    //bottom joint
    translate(connection_part_bottom_joint_pos) joint(0, 0);//, ext_l = connection_part_h - t / 2 - e * 10);
}

module bottom_part() {
    difference() {
        union() {
            difference() {
                union() {
                    roundedcube([w, bottom_part_l, bottom_part_t], center=true, radius=r, apply_to="z");
                    // we don't need rounded corners at the joint side
                    translate([0, bottom_part_l / 4, 0]) cube([w, bottom_part_l / 2, bottom_part_t], center=true);
                }
                // joint will be here
                translate(bottom_part_joint_pos) cut_for_joint(1);
                cut_h = bottom_part_t - t;
                translate([0, bottom_part_l / 2 - t, -bottom_part_t / 2 + cut_h / 2]) cube([w + e, t * 2 + e, cut_h + e], center=true);
            }
            // joint
            translate(bottom_part_joint_pos) joint(1);

            // rounding under joints
            translate([0, -t - t, 0]) {
                translate(bottom_part_joint_pos) {
                    resize([0, joint_d, 0]) {
                        intersection() {
                            a = bottom_part_t - t/2;
                            rotate([0, 90, 0]) cylinder(r=a, h=w, center=true);
                            translate([0, a/2, -a/2]) cube([w, a, a], center=true);
                        }
                    }
                }
            }
        }

        translate(kb_pos) {
            difference() {
                // kb
                cube([kb_w, kb_d, kb_cut_h + e], center=true);
                // top notches
                for (i = [0 : len(kb_top_notches) - 1]) {
                    translate([kb_top_notches[i] - kb_w / 2, kb_d / 2 - kb_top_notch_d / 2, 0]) {
                        cube([kb_top_notch_w, kb_top_notch_d, kb_top_notch_h], center=true);
                    }
                }
            }
            // bottom tabs
            for (i = [0 : len(kb_bottom_tabs) - 1]) {
                translate([kb_bottom_tabs[i] - kb_w / 2, -kb_d / 2 - kb_bottom_tab_d / 2, 0]) {
                    cube([kb_bottom_tab_w, kb_bottom_tab_d + e, kb_bottom_tab_h], center=true);
                }
            }
            // space for flex cable
            translate([-kb_w / 2 + kb_flex_pos, 0,  -kb_h / 2 - kb_flex_space_h / 2]) {
                cube([kb_flex_w, kb_d, kb_flex_space_h], center=true);
            }
        }
        // channel for kb wires
        translate(kb_wires_channel_pos) {
            cube(kb_wires_channel + [0, e, e], center=true);
        }
        // mcu board
        translate(mcu_board_pos) {
            cube(mcu_board + [0, 0, e], center=true);
        }
        // channel for tablet wires
        translate(tablet_wires_pos) {
            cube(tablet_wires + [0, e, e], center=true);
        }
        // cut in the joint for the tablet wires
        translate(tablet_wires_space_in_joint_pos) {
            cube(tablet_wires_space_in_joint + [0, 0, e], center=true);
        }
    }
}

module path(points, d = magnet_w*2, line_w = magnet_w/2, h=t, cube_dimensions = undef, path_line_offset_z = 0) {
    for (i = [1 : len(points) - 1]) {
        if (cube_dimensions == undef) {
            translate(points[i-1]) cylinder(d=d, h=h, center=true);
            translate(points[i]) cylinder(d=d, h=h, center=true);
        } else {
            translate(points[i-1]) cube(cube_dimensions, center=true);
            translate(points[i]) cube(cube_dimensions, center=true);
        }
        translate([0, 0, path_line_offset_z]) hull() {
            translate(points[i-1]) cylinder(d=line_w, h=h, center=true);
            translate(points[i]) cylinder(d=line_w, h=h, center=true);
        }
    }
}

difference() {
    union() {
        if (PART == "top" || PART == "all") {
            difference() {
                intersection() {
                    union() {
                        top_part();
                        translate(center_part_pos) center_part();
                        translate(connection_part_pos) connection_part();
                    }
                    if(TEST2) union() {
                        translate([cam_x, cam_y, 0]) scale([1.1, 1.1, 1]) cam_hole();
                        translate([-w/2 + t + t/3, -top_h / 2 + tablet_h / 3, 0]) cube([t / 3, tablet_h / 3, t], center=true);
                        translate([-w/2 + t + t/3, -top_h / 2, 0]) cube([t / 3, tablet_h, t], center=true);

                        top_joint_pos = [0, center_part_h / 2, 0];
                        bottom_joint_pos = [0, -center_part_h / 2, 0];
                        test_w = t * 5 / 2;
                        test_h = t * 4;
                        translate(center_part_pos) translate([-w/2 + test_w / 2, 0]) {
                            translate(top_joint_pos) cube([test_w, test_h - t, t], center=true);
                            translate([0, -t, 0])
                            translate(bottom_joint_pos) cube([test_w, test_h, t], center=true);
                        }
                        path(magnets);
                        translate(pogo_pins_pos + pogo_board_offset) cube([pogo_module_size.x * 1.2, pogo_module_size.y * 1.2, t], center=true);

                        path(line_w=tablet_wires.x * 2, cube_dimensions=tablet_wires_space_in_joint * 3, h=t, points=wire_groove_points);
                        path(line_w=tablet_wires.x * 2, d=1, h=t, points=[wire_groove_points[len(wire_groove_points)-1], pogo_pins_pos]);
                        path(line_w=tablet_wires.x, d=1, h=t/3, points=[[wire_groove_points[len(wire_groove_points)-1].x, pogo_pins_pos.y + t/2], wire_groove_points[len(wire_groove_points)-1], magnets[0]]);
                    }
                }
                if(TEST1) translate([cam_w + 12 + 5, top_h / 2 - tablet_h / 2 - connection_part_h / 2 - joint_d / 2, 0]) cube([w + e, top_h + center_part_h + connection_part_h + joint_d / 2 + e, t + e], center=true);
                cut_magnets();
                cut_pogo_pin_module();
            }
            *difference() {
                pogo_board_spikes();
                cut_pogo_pins();
            }
        }

        if ((PART == "bottom" || PART == "all") && !TEST1) {
            translate(bottom_part_offset) {
                intersection() {
                    bottom_part();
                    if(TEST2) intersection() {
                        union() {
                            translate([tablet_wires_pos.x + kb_flex_pos / 2, kb_pos.y, 0]) cube([3, kb_d, bottom_part_t], center=true);;
                            translate([tablet_wires_pos.x - kb_flex_pos / 2, kb_pos.y, 0]) cube([3, kb_d, bottom_part_t], center=true);
                            translate([0, -bottom_part_l / 2 + bottom_part_margin, 0]) cube([w, 3, bottom_part_t], center=true);
                            translate([0, -bottom_part_l / 2 + bottom_part_margin + kb_d, 0]) cube([w, 3, bottom_part_t], center=true);
                            translate([kb_pos.x + kb_w / 2, kb_pos.y, 0]) cube([3, kb_d + bottom_part_margin, bottom_part_t], center=true);
                            translate([kb_pos.x - kb_w / 2, kb_pos.y, 0]) cube([3, kb_d + bottom_part_margin, bottom_part_t], center=true);
                            translate([tablet_wires_pos.x, 0, 0]) cube([3, bottom_part_l, bottom_part_t], center=true);
                            translate(kb_wires_channel_pos)cube([mcu_board.x, kb_wires_channel_pos.y, bottom_part_t * 2] + [2, 2, 2], center=true);
                            translate(mcu_board_pos)cube(mcu_board + [2, 2, 2], center=true);
                            translate(tablet_wires_space_in_joint_pos) cube(tablet_wires_space_in_joint * 7/2, center=true);
                        }
                        translate([kb_pos.x, joint_d, kb_pos.z])cube([kb_w, bottom_part_l - bottom_part_margin * 2 + joint_d * 2, bottom_part_t] + [2, 5, 5], center=true);
                    }
                }
            }
        }
    }

    if (PART == "top" || PART == "all") {
        translate([0, 0, t / 2 - tablet_wires_space_in_joint.z / 2]) {
            path(line_w=tablet_wires.x, cube_dimensions=tablet_wires_space_in_joint + [0, 0, e], h=tablet_wires.z + e, path_line_offset_z=tablet_wires_space_in_joint.z/2 - tablet_wires.z/2, points=wire_groove_points);
        }
        translate([0, 0, t / 2 - pogo_module_size.z / 2]) {
            path(line_w=tablet_wires.x, h=pogo_module_size.z + e, points=[wire_groove_points[len(wire_groove_points)-1], pogo_pins_pos]);
        }
    }
}
