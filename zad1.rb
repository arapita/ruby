# Copyright Google Inc. 2010 All Rights Reserved
require 'open-uri'
require 'json'
require 'active_support/core_ext'
require 'net/http'

ELEVATION_BASE_URL = 'http://maps.google.com/maps/api/elevation/json'
CHART_BASE_URL = 'http://chart.apis.google.com/chart'

def getChart(chartData, chartDataScaling="-500,5000", chartType="lc",chartLabel="Elevation in Meters",chartSize="500x160", chartColor="orange", chart_args={})
    
  chart_args.merge!({
        cht: chartType,
        chs: chartSize,
        chl: chartLabel,
        chco: chartColor,
        chds: chartDataScaling,
        chxt: 'x,y',
        chxr: '1,-500,5000'
                    })


    dataString = 't:' + chartData.join(',')
    chart_args['chd'] = dataString
   
    chartUrl = CHART_BASE_URL + '?' + chart_args.to_query

    puts chartUrl
end

def getElevation(path="36.578581,-118.291994|36.23998,-116.83171",samples="100",sensor="false", elvtn_args={})

  elvtn_args.merge!({
        path: path,
        samples: samples,
        sensor: sensor
                    })
   
    url = ELEVATION_BASE_URL + '?' + elvtn_args.to_query

    resp = Net::HTTP.get_response(URI.parse(url))
    response = JSON.parse(resp.body)

    # Create a dictionary for each results[] object
    elevationArray = []
    for result in response['results']
      elevationArray << result["elevation"].round(0)
    end
    
    # Create the chart passing the array of elevation data
    getChart(elevationArray)   
end
        
      startStr = "36.578581,-118.291994"
    
      endStr = "36.23998,-116.83171"

    pathStr = startStr + "|" + endStr

    getElevation(pathStr)
