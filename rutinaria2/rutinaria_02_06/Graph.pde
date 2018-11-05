BarChart barChart;
public GPlot trendVolume;
GPointsArray trendVolumePoints;

//XYChart lineChart;

float values[];
String labels[];
float xsamples[];
float samples[];

void setupGraph() {
  barChart = new BarChart(this);
  barChart.setMinValue(0);
  barChart.setMaxValue(1.0);     
  barChart.showValueAxis(true);
  barChart.showCategoryAxis(true);

  //lineChart = new XYChart(this);
  xsamples = new float[TrendingTopic.TOTAL_SAMPLES];
  for (int i = 0; i < TrendingTopic.TOTAL_SAMPLES; i++) {
    xsamples[i] = i;
  }

  



  trendVolume = new GPlot(this);
  trendVolume.setYLim(0, TrendingTopic.MAX);
  trendVolume.setXLim(0, 1000);
  trendVolume.getTitle().setText("TWEETS HISTORICO");
  trendVolume.getTitle().setTextAlignment(LEFT);
  trendVolume.getTitle().setRelativePos(0);
  trendVolume.getYAxis().getAxisLabel().setText("cantidad");
  trendVolume.getYAxis().getAxisLabel().setTextAlignment(RIGHT);
  trendVolume.getYAxis().getAxisLabel().setRelativePos(1);
  
  //trendVolume.addLayer("layer1");
  
  
  //plot3.startHistograms(GPlot.VERTICAL);
  //plot3.getHistogram().setDrawLabels(true);
  //plot3.getHistogram().setRotateLabels(true);
  //plot3.getHistogram().setBgColors(new color[] {
  //  color(0, 0, 255, 50), color(0, 0, 255, 100), 
  //  color(0, 0, 255, 150), color(0, 0, 255, 200)
  //}
  //);

  //trendVolume.setYLim(-0.02, 0.45);
  //trendVolume.setXLim(-5, 5);


  //// Axis formatting and labels.
  //lineChart.showXAxis(true); 
  //lineChart.showYAxis(true); 
  //lineChart.setMinY(0);
  //lineChart.setMaxY(TrendingTopic.MAX);

  //lineChart.setYFormat("###,###");  // Monetary value in $US
  //lineChart.setXFormat("0000");      // Year

  //// Symbol colours
  //lineChart.setPointColour(color(180, 50, 50, 100));
  //lineChart.setPointSize(1);
  //lineChart.setLineWidth(1);
}



void updateGraphData(ArrayList<TrendingTopic> trending) {

  values = new float[trending.size()];
  labels = new String[trending.size()];    
  samples = new float[TrendingTopic.TOTAL_SAMPLES];

  for (int i = 0; i < values.length; i++) {
    TrendingTopic tt = trending.get(i);
    tt.update();
    values[i] = tt.load();
    labels[i] = tt.label();    



    int s = 0;

    for (Float f : tt.history) {    
      samples[s++] = (f != null ? f : Float.NaN); // Or whatever default you want.
    }

    //System.arraycopy(ArrayUtils.toPrimitive(new Float[0]), 0.0f) , 0, samples, 0, 1000);

    //if (i == 0) lineChart.setData(xsamples, samples);
  }
}

void renderGraphData() {
  pushMatrix();
  scale(0.75);
  translate(100, 100);
  barChart.setBarLabels(labels);
  barChart.setData(values);  
  textSize(textSize);

  float heightSpace = height/4;
  barChart.draw(0, 0, width/2, heightSpace);  
  // barra
  fill(255, 0, 0);
  noStroke();
  rect(0, heightSpace + 10, width/2 * query, 2);


  // Draw the third plot
  trendVolume.setPos(-50, heightSpace+50);
  trendVolume.setDim(width/2, heightSpace);

  trendVolume.beginDraw();
  trendVolume.drawBackground();
  trendVolume.drawBox();
  trendVolume.drawYAxis();
  trendVolume.drawTitle();
  //trendVolume.drawHistograms();
  trendVolume.endDraw();

  //lineChart.draw(0, heightSpace+50, width/2, heightSpace);  
  popMatrix();
}
