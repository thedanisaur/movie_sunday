<template>
  <q-page class="flex flex-center">
    <div class="q-pa-md q-mt-xl q-gutter-md row flex-center">
      <div id="rating" class="chart"></div>
      <div id="vote_ratio" class="chart"></div>
      <div id="series_average" class="chart"></div>
      <div id="voting_average" class="chart"></div>
      <!-- <div id="one_hundred" class="chart"></div> -->
      <div id="series_votes" class="chart"></div>
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
    }
  },
  async created () {
    const host = cfg.service.movie.host
    const port = cfg.service.movie.port
    const timeline = cfg.service.movie.timeline
    const response = await axios.get(`${host}:${port}${timeline}`)
    response.data.forEach((series, arr) => {
      if (!series.series_image) {
        series.series_image = 'missing.jpg'
      }
    })
    this.timeline = response.data
    console.log(this.timeline)
    const series = []
    const created = []
    const ratings = []
    const vote_ratio = []
    const good_votes = []
    const bad_votes = []
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
    for (var i = Object.values(this.timeline).length - 1; i >= 0; i--) {
      var s = this.timeline[i]
      series.push(s.series_title)
      created.push(s.series_created_on)
      ratings.push(s.series_rating)
      vote_ratio.push(Math.max(s.series_good_votes, 0) / Math.max(s.series_bad_votes, 1))
      good_votes.push(s.series_good_votes)
      bad_votes.push(s.series_bad_votes)
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
      stroke: {
        width: 2
      },
      dataLabels: {
        enabled: false,
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
          name: 'weighted rating',
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

    var options = {
      title: {
        text: 'Vote Breakdown'
      },
      chart: {
        type: 'area',
        stacked: false
      },
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
        text: 'Voting Average'
      },
      chart: {
        type: 'bar'
      },
      series: [
        {
          name: 'Voting Average',
          data: [dan_vote_avg.toFixed(2) + '%', nick_vote_avg.toFixed(2) + '%']
        },
      ],
      xaxis: {
        categories: ['Dan Vote Average', 'Nick Vote Average']
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


  },
  setup () {
    return {
    }
  },
  methods: {
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    },
    range (number, in_min, in_max, out_min, out_max) {
      return (number - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    },
  }
})
</script>
<style lang="scss" scoped>
.chart {
  min-width: 500px;
  margin: 25px auto;
}
</style>
