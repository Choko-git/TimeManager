<template>
  <div id="content">
    <div id="component-button">
        <ButtonClassic v-on:send="clock" :name="text" />

        <div v-if="isDisplayFormulaireClock">
            <FormClassic
            submitButtonName="Submit" 
            :formSubmitMethod="reset"
            httpMethod="post"
            apiRoute="/clocks"
            :fields="[
            { name: 'start', label:'Start', type: 'time', value: startHour},
            { name: 'breaktime', label:'Break Time', type: 'time' },
            { name: 'end', label:'End', type: 'time', value: endHour}
            ]"
            />
        </div>

        <div v-if="isDisplayHeureClock">
            <p> you clocked at : {{startHour}}</p>
        </div>

        <div v-if="isDisplayFinalWork">
            <p>you work {{totalWork}} with a breaktime of {{breaktime}} </p>
        </div>

        <h2> Home </h2>
        <ButtonClassic v-on:send="show" name="Vacation Request" />

        <div v-if="isDisplayVacation">
            <FormClassic
            submitButtonName="Submit"
            :formSubmitMethod="vacation"
            httpMethod="post"
            apiRoute="/vacation"
            :fields="[
            { name: 'startVacation', label: 'Start', type: 'date' },
            { name: 'endVacation', label: 'End', type: 'date' },
            ]"
            />
        </div>
        <div v-if="isDisplayVacation2">
            <p>Wait until your manager give a reponse for your vacation from {{startVacation}} to {{endVacation}} </p>
        </div>
    </div>
  </div>
</template>



<script>
import ButtonClassic from  "../../components/button/ButtonClassic";
import FormClassic from  "../../components/form/FormClassic";

export default {
    data: function(){
        return{
            text: "Clock In",
            isDisplayVacation: false,
            isDisplayVacation2: false,
            isDisplayFormulaireClock: false,
            isDisplayHeureClock: false,
            isDisplayFinalWork: false,
            dateDeb: null,
            dateFin: null,
            heuresDeb:null,
            minutesDeb:null,
            heuresFin:null,
            minutesFin:null,
            startHour:null,
            endHour:null,
            totalWork:null,
            breaktime:null,
            startVacation:null,
            endVacation:null
        }
    },
  components : {
    ButtonClassic,
    FormClassic,
  },

  methods : {

    reset: function(formData){
        this.isDisplay=false
        this.isDisplayFormulaireClock=false
        this.isDisplayFinalWork=true
        this.dateDeb=null
        this.text="Clock In"
        this.breaktime=formData.breaktime
        return {
            user_id: this.user.id,
            start: this.startHour,
            total_time: this.totalWork,
            end: this.endHour,
            status: false,
        }
      },

    clock: function(){
          if (this.text=="Clock Out") {
            this.isDisplayFormulaireClock=true 
            this.text="Back to Work"
            this.isDisplayHeureClock=false
            this.dateFin= new Date()
            this.heuresFin=this.dateFin.getHours()
            this.minutesFin=this.dateFin.getMinutes()
            if (this.minutesFin < 10){
                this.endHour = this.heuresFin + ":" + "0" + this.minutesFin
                }
            else {
                this.endHour = this.heuresFin + ":" + this.minutesFin
            }
            if (this.heuresFin < 10){
                this.endHour = "0" + this.endHour
                }

            if ((this.minutesFin - this.minutesDeb)<10){
                this.totalWork = (this.heuresFin - this.heuresDeb) + "h" + "0" + (this.minutesFin - this.minutesDeb)
            }
            else {
                this.totalWork = (this.heuresFin - this.heuresDeb) + "h" + (this.minutesFin - this.minutesDeb) 
            }
            if ((this.heuresFin - this.heuresDeb)<10){
            this.totalWork = "0" + this.totalWork
            }
          }
          else if (this.text=="Back to Work") {
            this.isDisplayFormulaireClock=true 
            this.text="Clock Out"
            this.isDisplayHeureClock=true
            this.isDisplayFormulaireClock=false
          }
          else {     
              this.isDisplayFinalWork=false
              this.isDisplayFormulaireClock=false 
              this.text="Clock Out"
              this.dateDeb= new Date()
              this.heuresDeb=this.dateDeb.getHours()
              this.minutesDeb=this.dateDeb.getMinutes()
              this.startHour = this.heuresDeb + ":" + this.minutesDeb
              if (this.minutesDeb < 10){
                this.startHour = this.heuresDeb + ":" + "0" + this.minutesDeb
                }
            else {
                this.startHour = this.heuresDeb + ":" + this.minutesDeb
            }
            if (this.heuresDeb < 10){
                this.startHour = "0" + this.startHour
                }
              this.isDisplayHeureClock=true
          }
      },

    show: function(){
       if (
        this.isDisplayVacation == true){
            this.isDisplayVacation=false;
        }
        else{
            this.isDisplayVacation=true;
        }
    },
    vacation: function(formData){
        this.startVacation=formData.startVacation
        this.endVacation=formData.endVacation
        this.isDisplayVacation=false
        this.isDisplayVacation2=true
    }
  }
  
};


</script>
<style lang="scss">
  #content {
    display: flex;
    height: 100vh;
    width: 100vw;
    & #left {
      width: 20%;
    }
    & #right {
      width: 80%;
    }
  }
</style>










