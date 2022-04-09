function fn() {
    var config = {
        baseUrl: 'http://localhost:8080',

        generateUUID: function () {
            var generated = java.util.UUID.randomUUID() + ''
            return generated.toUpperCase().replaceAll('-', '')
        },

        generateCreationDate: function () {
                    var now = new Date();
                    now.setHours(now.getHours() - 3);
                    return now.toISOString().split('.')[0]
                }
    };
    return config;
}