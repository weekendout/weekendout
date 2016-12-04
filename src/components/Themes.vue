<template>
<section class="wrapper departure section">
  <div class="inner">
    <h1>3. Themes</h1>
    <div class="row uniform">
      <div class="6u">
        <span class="image fit">
          <img src="~images/beaches.jpg" alt="airplane">
        </span>
      </div>
      <div class="6u">
        <span class="image fit">
          <img src="~images/mountains.jpg" alt="airplane">
        </span>
      </div>
      <div class="6u">
        <span class="image fit">
          <img src="~images/nature.jpg" alt="airplane">
        </span>
      </div>
      <div class="6u">
        <span class="image fit">
          <img src="~images/shopping.jpg" alt="airplane">
        </span>
      </div>
    </div>
  </div>
</section>
</template>
<script lang="coffee">
  {delay} = require('src/utilities')

  module.exports =
    name: 'Themes'
    components:
      Scrollfire: require('vue-scrollfire')
    data: ->
      detectingLocation: false
    methods:
      detectLocation: ->
        console.log 'detectingLocation'
        @detectingLocation = true
        delay 5000, => @detectingLocation = false


    ready: -> window.addEventListener('scroll', this.handleScroll);
</script>

<style lang="sass" scoped>
.section:before,
.section:after
  display: none;

.departure.section
  margin: 0;
  min-height: 400px;
  background-image: linear-gradient(to top, rgba(46, 49, 65, 0.8), rgba(46, 49, 65, 0.8)), url('~images/unsplash/airplane2.jpg');
  background-size: auto, cover;
  background-position: center;
</style>
