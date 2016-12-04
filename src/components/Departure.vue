<template>
<section class="wrapper departure section">
  <div class="inner">
    <h1>1. Departure</h1>
    <scrollfire @entered="detectLocation" initial/>
    <transition name="fade" mode="out-in">
      <h2 v-if="detectingLocation">Finding your location, please wait... <i class="fa fa-spinner fa-pulse fa-2x fa-fw"></i></h2>
      <form v-else method="post" action="#">
        <div class="field">
          <label for="city">City</label>
          <input type="text" name="city" id="city" value="Berlin"/>
        </div>
        <div class="field">
          <label for="country">Country</label>
          <input type="text" name="country" id="country" value="Germany" />
        </div>
        <ul class="actions">
          <li><input type="submit" value="Next" /></li>
        </ul>
      </form>
    </transition>
  </div>
</section>
</template>
<script lang="coffee">
  {delay} = require('src/utilities')

  module.exports =
    name: 'Departure'
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
