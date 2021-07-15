<template>
  <v-card>
    <v-card-title>
      <h3>Packages list</h3>
    </v-card-title>

    <v-divider />

    <v-card-text class="token-list--table">
      <v-data-table
        :headers="headers"
        :loading="isWaiting"
        :items="getEnumerableItems"
        :pagination.sync="pagination"
        :total-items="getEnumerableTotal"
        :rows-per-page-items="rowsPerPageConfig"
        disable-initial-sort
      >
        <template slot="items" slot-scope="props">
          <td>{{ props.item._id }}</td>
          <td>{{ props.item.checksum }}</td>
          <td>{{ props.item.name }}</td>
          <td>{{ props.item.version }}</td>
          <td>
            <router-link :to="`/packages/${props.item._id}`">
              View
            </router-link>
          </td>
        </template>
      </v-data-table>
    </v-card-text>
  </v-card>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import { rowsPerPageConfig } from "helpers/table-helper";

export default {
  name: "package",

  data: () => ({
    rowsPerPageConfig,
  }),

  computed: {
    ...mapGetters("packages", [
      "getEnumerableTotal",
      "getEnumerableItems",
      "isWaiting",
    ]),

    headers() {
      return [
        { text: "ID", value: "id" },
        { text: "Checksum", value: "checksum" },
        { text: "Name", value: "name" },
        { text: "Latest version", value: "version" },
        { text: "Actions", value: "", sortable: false },
      ];
    },

    pagination: {
      get: () => ({}),

      set(val) {
        const { page, rowsPerPage } = val;
        this.receivePackages({ page, per: rowsPerPage });
      },
    },
  },

  mounted() {
    this.receivePackages();
  },

  methods: mapActions("packages", ["receivePackages"]),
};
</script>
