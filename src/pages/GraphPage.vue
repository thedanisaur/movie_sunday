<template>
  <q-page class="flex flex-center">
    <q-toolbar :class="'absolute-top ' + bgColor()" />
    <div class="q-pa-md q-mt-xl q-gutter-md row flex-center">
      <q-card
        v-for="chart in charts"
        bordered
        :key="chart.id"
      >
        <div :id="chart.id" class="chart"></div>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import { ref, defineComponent } from 'vue'
import axios from 'axios'
import cfg from '../../movie_sunday.config.json'
import ApexCharts from 'apexcharts'


export default defineComponent({
  name: 'TimelinePage',
  data () {
    return {
      charts: [
        { id: "rating" },
        { id: "vote_ratio" },
        { id: "series_votes" },
        { id: "series_average" },
        { id: "voting_average" },
        { id: "one_hundred" },
        { id: "vote_breakdown"},
        { id: "top_by_vote_ratio"},
      ],
    }
  },
  async created () {
    const host = cfg.service.movie.host
    const port = cfg.service.movie.port
    const timeline = cfg.service.movie.timeline
    const response = await axios.get(`${host}:${port}${timeline}`)
    this.timeline = response.data
    const series = []
    const created = []
    const ratings = []
    const vote_ratio = []
    const good_votes = []
    const bad_votes = []
    const person = []
    var dan_series_avg = 0
    var dan_number_of_series = 0
    var nick_series_avg = 0
    var nick_number_of_series = 0
    var dan_good_votes = 0
    var dan_movies_voted = 0
    var dan_vote_avg = 0
    var nick_good_votes = 0
    var nick_movies_voted = 0
    var nick_vote_avg = 0
    var dan_one_hundred = 0
    var nick_one_hundred = 0
    var total_good = 0
    var total_bad = 0
    for (var i = Object.values(this.timeline).length - 1; i >= 0; i--) {
      var s = this.timeline[i]
      series.push(s.series_title)
      created.push(s.series_created_on)
      ratings.push(s.series_rating)
      vote_ratio.push(Math.max(s.series_good_votes, 0) / Math.max(s.series_bad_votes, 1))
      good_votes.push(s.series_good_votes)
      bad_votes.push(s.series_bad_votes)
      person.push(s.series_chosen_by)
      if (s.series_chosen_by === "dan") {
        dan_series_avg += parseFloat(s.series_rating)
        dan_number_of_series += 1
        if (s.series_rating == 100) {
          dan_one_hundred += 1
        }
      } else {
        nick_series_avg += parseFloat(s.series_rating)
        nick_number_of_series += 1
        if (s.series_rating == 100) {
          nick_one_hundred += 1
        }
      }
      for (var j = 0; j < s.series_movies.length; j++) {
        var m = s.series_movies[j]
        if (m.dan_vote !== "NULL") {
          dan_movies_voted += 1
          if (m.dan_vote === "GOOD") {
            dan_good_votes += 1
          }
        }
        if (m.nick_vote !== "NULL") {
          nick_movies_voted += 1
          if (m.nick_vote === "GOOD") {
            nick_good_votes += 1
          }
        }
      }
    }
    dan_series_avg = dan_series_avg / dan_number_of_series
    nick_series_avg = nick_series_avg / nick_number_of_series
    dan_vote_avg = dan_good_votes / dan_movies_voted * 100
    nick_vote_avg = nick_good_votes / nick_movies_voted * 100
    const min = Math.min(...vote_ratio)
    const max = Math.max(...vote_ratio)
    for (var i = 0; i < vote_ratio.length; i++) {
      vote_ratio[i] = this.range(vote_ratio[i], min, max, 0, 10).toFixed(3)
    }
    var options = {
      title: {
        text: 'Series Ratings'
      },
      chart: {
        type: 'area'
      },
      series: [{
        name: 'Rating',
        data: ratings
      }],
      xaxis: {
        categories: series,
        labels: {
          show: true,

          // series,
        },
      },
      yaxis: {
        min: 0,
        max: 100
      },
      stroke: {
        width: 2
      },
      dataLabels: {
        enabled: false,
      },
      colors: ['#999999'],
      fill: {
        type: 'gradient',
        gradient: {
          shade: 'light',
          type: "vertical",
          shadeIntensity: 1,
          inverseColors: false,
          gradientToColors: ['#FF4560'], // red at top
          stops: [0, 50, 100],
          colorStops: [
            {
              offset: 0,
              color: '#00E396', // green at y = 0
              opacity: 1
            },
            {
              offset: 50,
              color: '#FEB019', // yellow-orange mid
              opacity: 1
            },
            {
              offset: 100,
              color: '#FF4560', // red at y = 10
              opacity: 1
            }
          ]
        }
      },
    }
    var chart = new ApexCharts(document.querySelector("#rating"), options);
    chart.render();

    var options = {
      title: {
        text: 'Series Rating Average'
      },
      chart: {
        type: 'bar'
      },
      series: [
        {
          name: '',
          data: [dan_series_avg.toFixed(2), nick_series_avg.toFixed(2)]
        },
      ],
      xaxis: {
        categories: ['Dan Series Average', 'Nick Series Average']
      },
      yaxis: {
        min: 0,
        max: 100
      },
      stroke: {
        width: 2
      },
      plotOptions: {
        bar: {
          colors: {
            ranges: [
              {
                from: 0,
                to: 25,
                color: '#FF4560' // red
              },
              {
                from: 25,
                to: 50,
                color: '#FF7B3D' // orange
              },
              {
                from: 50,
                to: 75,
                color: '#FEB019' // yellow
              },
              {
                from: 75,
                to: 100,
                color: '#00E396' // green
              }
            ]
          }
        }
      }
    }
    var chart = new ApexCharts(document.querySelector("#series_average"), options);
    chart.render();

    var options = {
      title: {
        text: 'Rating by Vote Ratio'
      },
      chart: {
        type: 'area'
      },
      series: [
        {
          name: 'Rating',
          data: vote_ratio
        },
      ],
      xaxis: {
        categories: series
      },
      yaxis: {
        max: 10,
        min: 0
      },
      stroke: {
        width: 2
      },
      dataLabels: {
        enabled: false,
      },
    }
    var chart = new ApexCharts(document.querySelector("#vote_ratio"), options);
    chart.render();

    const colorMap = {
      "dan": '#00E396',
      "nick": '#6045FF'
    }

    var top_10_vote_ratio = []
    for (let i = 0; i < series.length; i++) {
      top_10_vote_ratio.push({ series_name: series[i], vote_ratio: parseFloat(vote_ratio[i]), person: person[i] })
    }
    top_10_vote_ratio.sort((a, b) => b.vote_ratio - a.vote_ratio);
    const top_10_vote_ratio_data = top_10_vote_ratio.map(item => ({
      x: item.series_name,
      y: item.vote_ratio,
      fillColor: colorMap[item.person]
    })).slice(0, 10);

    var options = {
      title: {
        text: 'Top 10 by Vote Ratio'
      },
      chart: {
        type: 'bar'
      },
      series: [
        {
          name: 'Dan',
          data: top_10_vote_ratio_data
        },
        {
          name: 'Nick',
          data: top_10_vote_ratio_data
        },
      ],
      yaxis: {
        max: 10,
        min: 0
      },
      dataLabels: {
        enabled: false,
      },
      legend: {
        show: true,
      },
      plotOptions: {
        bar: {
          horizontal: false,
        }
      },
      colors: ['#00E396', '#6045FF'],
      // colors: top_10_vote_ratio_data.map(item => colorMap[item.fillColor] || '#999'),
    }
    var chart = new ApexCharts(document.querySelector("#top_by_vote_ratio"), options);
    chart.render();

    var options = {
      title: {
        text: 'Vote Breakdown'
      },
      chart: {
        type: 'area',
        stacked: false
      },
      colors: ['#00E396', '#FF4560'],
      series: [
        {
          name: 'good votes',
          data: good_votes
        },
        {
          name: 'bad votes',
          data: bad_votes
        },
      ],
      xaxis: {
        categories: series
      },
      yaxis: {
        min: 0,
      },
      stroke: {
        width: 1
      },
      dataLabels: {
        enabled: false,
      },
    }
    var chart = new ApexCharts(document.querySelector("#series_votes"), options);
    chart.render();

    var options = {
      title: {
        text: 'Postive Vote Percentage'
      },
      chart: {
        type: 'bar'
      },
      series: [
        {
          name: 'Good Percentage',
          data: [dan_vote_avg.toFixed(2) + '%', nick_vote_avg.toFixed(2) + '%']
        },
      ],
      xaxis: {
        categories: ['Dan Postive Percentage', 'Nick Postive Percentage']
      },
      yaxis: {
        min: 0,
        max: 100
      },
    }
    var chart = new ApexCharts(document.querySelector("#voting_average"), options);
    chart.render();

    var options = {
      title: {
        text: 'Number of 100%ers'
      },
      chart: {
        type: 'bar',
      },
      series: [
        {
          name: 'One Hundred Percent',
          data: [dan_one_hundred, nick_one_hundred]
        },
      ],
      xaxis: {
        categories: ['Dan', 'Nick']
      },
    }
    var chart = new ApexCharts(document.querySelector("#one_hundred"), options);
    chart.render();

    var options = {
      title: {
        text: 'Vote Breakdown'
      },
      chart: {
        type: 'donut',
      },
      series: [bad_votes.reduce((acc, curr) => acc + Number(curr), 0), good_votes.reduce((acc, curr) => acc + Number(curr), 0)],
      labels: ['Bad', 'Good'],
    }
    var chart = new ApexCharts(document.querySelector("#vote_breakdown"), options);
    chart.render();

  },
  setup () {
    return {
    }
  },
  methods: {
    bgColor () {
      if (this.$q.dark.isActive) {
        return "bg-grey-10"
      } else {
        return "bg-grey-2"
      }
    },
    range (number, in_min, in_max, out_min, out_max) {
      return (number - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    },
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    },
  }
})
</script>
<style lang="scss" scoped>
.chart {
  min-width: 550px;
  margin: 25px;
}
</style>
