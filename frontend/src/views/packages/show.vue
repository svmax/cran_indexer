<template>
  <v-card>
    <v-card-title>
      <v-btn to="/" class="primary mr-4" rounded> Back </v-btn>

      <h3>Package details</h3>
    </v-card-title>

    <v-divider />

    <v-card-text>
      <div><strong>ID:</strong> {{ info.id }}</div>
      <div><strong>Name:</strong> {{ info.name }}</div>
      <div><strong>Checksum:</strong> {{ info.checksum }}</div>
    </v-card-text>

    <v-card-text class="token-list--table">
      <div class="card__text token-list--table">
        <div>
          <div class="table__overflow">
            <table class="datatable table">
              <thead>
                <tr>
                  <th class="column text-xs-left">Number</th>
                  <th class="column text-xs-left">Title</th>
                  <th class="column text-xs-left">Description</th>
                  <th class="column text-xs-left">Published at</th>
                  <th class="column text-xs-left">Authors</th>
                  <th class="column text-xs-left">Maintainers</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="version in info.versions" :key="version.title">
                  <td>{{ version.number }}</td>
                  <td>{{ version.title }}</td>
                  <td>{{ version.description }}</td>
                  <td>{{ version.published_at }}</td>
                  <td>{{ prepareContributors(version.authors) }}</td>
                  <td>{{ prepareContributors(version.maintainers) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
import { mapActions, mapGetters } from "vuex";

export default {
  name: "versions",

  computed: mapGetters("packages", {
    info: "getGeneralInfo",
  }),

  beforeMount() {
    this.receivePackageWithVersions(this.$route.params.id);
  },

  methods: {
    ...mapActions("packages", ["receivePackageWithVersions"]),

    prepareContributors: (arr) =>
      (arr || [])
        .map(({ name, email }) => (email ? `${name} (${email})` : name))
        .join(", "),
  },
};
</script>