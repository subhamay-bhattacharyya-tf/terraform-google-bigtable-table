package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestBigtableTableChangeStream tests creating a Bigtable table with change stream retention configuration.
func TestBigtableTableChangeStream(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("tt-stream-%s", unique)
	projectID := mustEnv(t, "GOOGLE_CLOUD_PROJECT")

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/bigtable/with-change-stream",
		NoColor:      true,
		Vars: map[string]interface{}{
			"environment":   "devl",
			"project_code":  "test",
			"base_name":     baseName,
			"instance_name": fmt.Sprintf("tt-instance-%s", unique),
			"project_id":    projectID,
		},
	}

	// Destroy must happen after disabling the change stream; see cleanup below.
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	outputName := terraform.Output(t, tfOptions, "table_name")
	require.Contains(t, outputName, baseName)

	// GCP refuses to delete a table with an active change stream.
	// Disable it first by re-applying with change_stream_retention unset, then destroy.
	tfOptions.Vars["change_stream_retention"] = ""
	terraform.Apply(t, tfOptions)
	terraform.Destroy(t, tfOptions)
}
