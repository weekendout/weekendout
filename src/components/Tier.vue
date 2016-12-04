<template>
<section class="tier section wrapper" :class="[tier]">
  <div class="inner">
    <h1>2. Class</h1>

    <form method="post" action="#">
      <div class="row">
        <div class="4u 12u$(small)">
          <input type="radio" id="demo-priority-low" name="demo-priority" value="budget" v-model="tier">
          <label for="demo-priority-low">Budget</label>
        </div>
        <div class="4u 12u$(small)">
          <input type="radio" id="demo-priority-normal" name="demo-priority" value="turist" v-model="tier">
          <label for="demo-priority-normal">Turistic</label>
        </div>
        <div class="4u$ 12u$(small)">
          <input type="radio" id="demo-priority-high" name="demo-priority" value="confort" v-model="tier">
          <label for="demo-priority-high">Confort</label>
        </div>
      </div>
      <transition mode="out-in">
        <div key="budget" v-if="tier == 'budget'">
          <h2>Up to 100€</h2>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto libero reiciendis, in est nulla assumenda ducimus et perspiciatis repellat voluptatem excepturi dicta laboriosam ea odit ullam, totam possimus dignissimos quo.</p>
        </div>
        <div key="turist" v-if="tier == 'turist'">
          <h2>Up to 300€</h2>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto libero reiciendis, in est nulla assumenda ducimus et perspiciatis repellat voluptatem excepturi dicta laboriosam ea odit ullam, totam possimus dignissimos quo.</p>
        </div>
        <div key="confort" v-if="tier == 'confort'">
          <h2>More than 300€</h2>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto libero reiciendis, in est nulla assumenda ducimus et perspiciatis repellat voluptatem excepturi dicta laboriosam ea odit ullam, totam possimus dignissimos quo.</p>
        </div>

      </transition>
      <ul class="actions">
        <li><input type="submit" value="Next" /></li>
      </ul>
    </form>
<!--     <div class="features">
      <article>
        <a href="#" class="image"><img src="~images/unsplash/tuk-tuk.jpg" alt="Tuk Tuk"></a>
        <h3 class="major">Budget - MAX 100€</h3>
        <p>Bus + hostels</p>
        <a href="#" class="special">Learn more</a>
      </article>
      <article>
        <a href="#" class="image"><img src="~images/unsplash/train.jpg" alt="Train"></a>
        <h3 class="major">Premium - MAX 500€</h3>
        <p>Bus + Airplain + Hotels</p>
        <a href="#" class="special">Learn more</a>
      </article>
      <article>
        <a href="#" class="image"><img src="~images/unsplash/train.jpg" alt="Train"></a>
        <h3 class="major">Luxury - MIN 700€</h3>
        <p>Bus + Airplaine + Uber + 5star hotels</p>
        <a href="#" class="special">Learn more</a>
      </article>
    </div>
 -->    </transition>
  </div>
</section>
</template>
<script lang="coffee">
  {delay} = require('src/utilities')

  module.exports =
    name: 'Tier'
    data: ->
      tier: 'turist'

    methods:
      detectLocation: ->
        console.log 'detectingLocation'
        @detectingLocation = true
        delay 5000, => @detectingLocation = false


    ready: -> window.addEventListener('scroll', this.handleScroll);
</script>

<style lang="sass" scoped>
.tier.section
  background-size: auto, cover;
  background-position: center;
  margin: 0;

.section:before,
.section:after
  display: none;

.tier.section.budget
  background-image: linear-gradient(to top, rgba(46, 49, 65, 0.8), rgba(46, 49, 65, 0.8)), url('~images/unsplash/tuk-tuk.jpg');

.tier.section.turist
  background-image: linear-gradient(to top, rgba(46, 49, 65, 0.8), rgba(46, 49, 65, 0.8)), url('~images/unsplash/train.jpg');

.tier.section.confort
  background-image: linear-gradient(to top, rgba(46, 49, 65, 0.8), rgba(46, 49, 65, 0.8)), url('~images/unsplash/airplane-interior.jpg');

</style>
