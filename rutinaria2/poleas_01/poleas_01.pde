/**
 * Generative wheel designs utilizing Vec2D polar coordinates,
 * splines and unit conversion. By default each design is exported as
 * PDF & PNG file, but can be turned off by setting the doExport flag to false.
 *
 * Usage: if export is enabled simply run & wait until all permutations
 * have been generated. Else press 'x' to activate next permutation or
 * use - / = to adjust the ARC_WIDTH parameter which defines the
 * size of the cutouts.
 *
 * (c) 2010 Karsten Schmidt, PostSpectacular Ltd.
 *
 * More info: http://toxiclibs.org/2010/01/re-inventing-the-wheel/
 * Source code licensed under GPL v3.0. See http://www.gnu.org/licenses/gpl.html
 */

import processing.pdf.*;

import toxi.geom.*;
import toxi.math.conversion.*;

import java.util.*;
// bleed in mm
int BLEED = 6;

// wheel radii & document size
float R = (float) UnitTranslator.millisToPoints(370 / 2);
float W = 2 * R + 2 * (float)UnitTranslator.millisToPoints(BLEED);
float EMPTY_CORE_SIZE = (float)UnitTranslator.millisToPoints(5);

// start number of main segments
int NUM_SEGMENTS = 3;

// normalized parameters
float INSET_RADIUS = 0.8f;
float OFFSET = 0.1f;
float CORE_RADIUS = 0.15f;
float ALTCORE_RADIUS = 0.3f;
float ARC_WIDTH = 0.4f;

// optional mounting holes
int NUM_DOTS = 18;
float DOT_RADIUS = 0.97f;
float DOTSIZE = (float)UnitTranslator.millisToPoints(2);

// number of subdivisions for spline vertex computation
int SPLINE_SUBDIV = 20;

// flag for PDF & PNG export of all permutations
boolean doExport = true;

public void setup() {
  println(W);
  size(1083,1083);
  // turn off automatic redraws when not exporting
  if (!doExport) {
    noLoop();
  }
}

public void draw() {
  String frameID =
    "wheel-" + NUM_SEGMENTS + "-" + nf(INSET_RADIUS, 1, 2) + "-"
    + nf(ALTCORE_RADIUS, 1, 2) + "-"
    + nf(CORE_RADIUS, 1, 2) + "-" + nf(ARC_WIDTH, 1, 2);
  println(frameID);
  if (doExport) {
    beginRecord(PDF, "out/" + frameID + ".pdf");
  }
  background(255);
  noStroke();
  fill(0);
  translate(width / 2, height / 2);
  ellipseMode(RADIUS);
  ellipse(0, 0, R, R);
  fill(255);
  ellipse(0, 0, EMPTY_CORE_SIZE, EMPTY_CORE_SIZE);
  // main holes
  drawHoles((INSET_RADIUS + OFFSET) * R, CORE_RADIUS * R, (INSET_RADIUS
    + OFFSET + CORE_RADIUS)
    / 2 * R, ARC_WIDTH, 0, NUM_SEGMENTS);
  if (CORE_RADIUS >= 0.5) {
    drawHoles(CORE_RADIUS * 0.85f * R, 0.2f * R,
    (CORE_RADIUS * 0.85f + 0.2f) / 2 * R, ARC_WIDTH, 0,
    NUM_SEGMENTS);
  }
  // small cutouts
  drawHoles(INSET_RADIUS * R, ALTCORE_RADIUS * R,
  (INSET_RADIUS + ALTCORE_RADIUS) / 2 * R, ARC_WIDTH / 2, PI
    / NUM_SEGMENTS, NUM_SEGMENTS);
  if (ALTCORE_RADIUS >= 0.5) {
    drawHoles(ALTCORE_RADIUS * 0.85f * R, 0.3f * R,
    (ALTCORE_RADIUS * 0.85f + 0.3f) / 2 * R, ARC_WIDTH / 2, PI
      / NUM_SEGMENTS, NUM_SEGMENTS);
  }
  // drill holes
  drawDots(NUM_DOTS, DOT_RADIUS * R, DOTSIZE);
  if (doExport) {
    endRecord();
    saveFrame("png/" + frameID + ".png");
    nextPermutation();
  }
}

void drawDots(int num, float radius, float s) {
  float delta = TWO_PI / num;
  for (int i = 0; i < num; i++) {
    Vec2D p = new Vec2D(radius, i * delta).toCartesian();
    ellipse(p.x, p.y, s, s);
  }
}

void drawHoles(float outerR, float innerR, float centerR, float radiusWidth, float thetaOffset, int num) {
  radiusWidth *= PI / num;
  Spline2D s = new Spline2D();
  // define point in polar coordinates, then convert them
  Vec2D p = new Vec2D(outerR, 0).toCartesian();
  Vec2D a = new Vec2D(outerR, radiusWidth).toCartesian();
  Vec2D b = new Vec2D(centerR, radiusWidth).toCartesian();
  Vec2D c = new Vec2D(innerR, 0).toCartesian();
  Vec2D d = new Vec2D(centerR, -radiusWidth).toCartesian();
  Vec2D e = new Vec2D(outerR, -radiusWidth).toCartesian();
  // add points to spline & compute
  s.add(p).add(a).add(b).add(c).add(d).add(e).add(p);
  java.util.List verts = s.computeVertices(SPLINE_SUBDIV);
  float delta = TWO_PI / num;
  for (int i = 0; i < num; i++) {
    pushMatrix();
    rotate(i * delta + thetaOffset);
    drawPath(verts);
    popMatrix();
  }
}

void drawPath(java.util.List verts) {
  beginShape();
  for (Iterator i = verts.iterator(); i.hasNext();) {
    Vec2D v = (Vec2D) i.next();
    vertex(v.x, v.y);
  }
  endShape();
}

public void keyPressed() {
  if (key == 'x') {
    nextPermutation();
  } else if (key == '-') {
    ARC_WIDTH -= 0.02;
  } else if (key == '=') {
    ARC_WIDTH += 0.02;
  }
  redraw();
}

void nextPermutation() {
  CORE_RADIUS += 0.2;
  if (CORE_RADIUS >= INSET_RADIUS) {
    CORE_RADIUS = 0.15f;
    ALTCORE_RADIUS += 0.2f;
    if (ALTCORE_RADIUS >= INSET_RADIUS) {
      ALTCORE_RADIUS = 0.3f;
      INSET_RADIUS += 0.1f;
      if (INSET_RADIUS > 0.8) {
        NUM_SEGMENTS++;
        INSET_RADIUS = 0.8f;
        if (NUM_SEGMENTS > 12) {
          exit();
        }
      }
    }
  }
}
