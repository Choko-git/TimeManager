<template>
    <div class="main-div">
      
      <div id="username">
        <h1>{{ employee.username }}</h1>
      </div>

    
      <div id="teams">
        <h2 v-if="employee.teams.lenght">Actual teams {{ employee.teams }}</h2>
        <h2 v-if="!employee.teams.lenght">{{ employee.username }} don't have teams associated</h2>    
     
        <div id="working-times">
            <h3>Working Time :</h3>

            <div id="currentDate">        
                <a v-on:click="editToday('remove')" id="leftArrow">&#8592;</a>
                {{ today }} 
                <a v-on:click="editToday('add')" id="rightArrow">&#8594;</a>            
            </div>

            <div id="working-time-expected">
                <h4>Expected:  {{ startExpected }} - {{ endExpected }}</h4>
            </div>

            <div id="working-time-actual">
                <h4>Actual: {{ startActual }} - {{ endActual }} </h4>
            </div>

        </div> 

      </div>        

       

    </div>
</template>

<script>
import moment from "moment";

export default {
    
    data: function(){
      return {
          today: moment().format("YYYY-MM-DD"),
          employee: null,
          id: 5,
          startActual: null,
          endActual: null,
          startExpected: null,
          endExpected: null,
          isWorking: null
       } 
    },
    created: function () {
        this.initData();
        this.actualClock();
        this.expectedClock();

     },
    watch: {
    "$store.state.data": function () {
      this.initData();
      this.actualClock();
      this.expectedClock();
    },
  },
  methods: {
    initData() {
        const employees = this.$store.state.data?.employees;
        this.employee = employees?.find(employee => employee.id == this.id);
        console.log(this.employee);
    },
    actualClock: function() {
        let clocks = this.employee.clocks
        for(let clock in clocks)
        {         
            let cl = clocks[clock]
            if (cl.start.substr(0,10) == this.today) {
                this.startActual = cl.start.substr(11,8)
                this.endActual = cl.end.substr(11,8)
                return 0
            }
        }
        this.startActual = null
        this.endActual = null
        return -1
    },

    expectedClock: function() {
        let workingtimes = this.employee.workingtimes
        for(let workingtime in workingtimes)
        {         
            let wt = workingtimes[workingtime]
            if (wt.start.substr(0,10) == this.today) {
                this.startExpected = wt.start.substr(11,8)
                this.endExpected = wt.end.substr(11,8)
                return 0
            }
        }
        this.startExpected = null
        this.endExpected = null
        return -1
    },

    editToday: function(action){
        if(action == "add"){
            let n_today = moment(this.today).add(1,'days');
            this.today = n_today.format("YYYY-MM-DD");
        } else {
            let n_today = moment(this.today).add(-1,'days');
            this.today = n_today.format("YYYY-MM-DD");       
        }
        this.actualClock();
        this.expectedClock();
    },
    getEmployee(employeesData, allEmployees) {
        console.log(employeesData);
        console.log(allEmployees)
    }

  }
};

</script>