<template>
  <v-app>
    <v-toolbar app>
      <v-toolbar-title>CRAN INDEXER</v-toolbar-title>
    </v-toolbar>

    <v-content>
      <v-container grid-list-md fluid>
        <v-layout wrap>
          <v-flex xs12>
            <router-view />
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
export default {
  name: "layout",
};
</script>
