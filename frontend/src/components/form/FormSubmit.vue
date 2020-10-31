<template>
  <div class="form-submit">
    <span class="form-error">{{ error }}</span>
    <ButtonSubmit :name="buttonName" />
  </div>
</template>

<script>
import ButtonSubmit from "../button/ButtonSubmit";

export default {
    props: ['buttonName', 'error'],
    components: {
        ButtonSubmit
    }
}
</script>

<style lang="scss">
    .form-submit{
        @include flex-container;
        justify-content: space-between;
    }
</style>