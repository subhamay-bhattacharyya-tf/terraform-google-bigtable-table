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

// TestBigtableTableColumnFamily tests creating a Bigtable table with column family configuration.
func TestBigtableTableColumnFamily(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("tt-cf-%s", unique)

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/bigtable/with-column-family",
		NoColor:      true,
		Vars: map[string]interface{}{
			"environment":   "devl",
			"project_code":  "test",
			"base_name":     baseName,
			"instance_name": fmt.Sprintf("tt-instance-%s", unique),
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	outputName := terraform.Output(t, tfOptions, "table_name")
	require.Contains(t, outputName, baseName)
}
