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

// TestBigtableTableSplitKeys tests creating a Bigtable table with pre-split keys configuration.
func TestBigtableTableSplitKeys(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("tt-split-%s", unique)
	projectID := mustEnv(t, "GOOGLE_CLOUD_PROJECT")

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/bigtable/with-split-keys",
		NoColor:      true,
		Vars: map[string]interface{}{
			"environment":   "devl",
			"project_code":  "test",
			"base_name":     baseName,
			"instance_name": fmt.Sprintf("tt-instance-%s", unique),
			"project_id":    projectID,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	outputName := terraform.Output(t, tfOptions, "table_name")
	require.Contains(t, outputName, baseName)
}
