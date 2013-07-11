all: basic_hmmgs.txt align cdhit primer_summary.txt

hmmgs_result_prefix= gene_starts.txt

.PHONY: align cdhit

basic_hmmgs.txt: $(BLOOM) gene_starts.txt
	java -Xmx3g -jar $(JAR_DIR)/hmmgs.jar search 1 30 $(BLOOM) for_enone.hmm rev_enone.hmm gene_starts.txt > basic_hmmgs.txt 2> hmmgs.stderr

primer_summary.txt: align basic_hmmgs.txt
	python2.7 ../../scripts/primer_check.py primer_details.txt aligned_nucl_cdhit.fasta 2 > primer_summary.txt 2> primer_summary.stderr

$(hmmgs_result_prefix)_prot.fasta: basic_hmmgs.txt
$(hmmgs_result_prefix)_nucl.fasta: basic_hmmgs.txt

align: aligned_prot.fasta aligned_nucl.fasta aligned_nucl_cdhit.fasta

aligned_prot.sto: $(hmmgs_result_prefix)_prot.fasta
	hmmalign --allcol -o aligned_prot.sto for_enone.hmm $(hmmgs_result_prefix)_prot.fasta

aligned_prot.fasta: aligned_prot.sto
	java -cp $(JAR_DIR)/ReadSeq.jar edu.msu.cme.rdp.readseq.ToFasta aligned_prot.sto > aligned_prot.fasta || rm aligned_prot.fasta

aligned_nucl.fasta: aligned_prot.fasta $(hmmgs_result_prefix)_nucl.fasta
	java -cp $(JAR_DIR)/FungeneUtils.jar edu.msu.cme.rdp.fungene.cli.AlignNuclCmd aligned_prot.fasta $(hmmgs_result_prefix)_nucl.fasta aligned_nucl.fasta /dev/null

cdhit: prot_cdhit.fasta nucl_cdhit.fasta

nucl_cdhit.fasta: $(hmmgs_result_prefix)_nucl.fasta
	cd-hit-est -i $(hmmgs_result_prefix)_nucl.fasta -o nucl_cdhit.fasta -c .93

prot_cdhit.fasta: $(hmmgs_result_prefix)_prot.fasta
	cd-hit -i $(hmmgs_result_prefix)_prot.fasta -o prot_cdhit.fasta -c .95

aligned_nucl_cdhit.fasta: aligned_prot.fasta nucl_cdhit.fasta
	java -cp $(JAR_DIR)/FungeneUtils.jar edu.msu.cme.rdp.fungene.cli.AlignNuclCmd aligned_prot.fasta nucl_cdhit.fasta aligned_nucl_cdhit.fasta /dev/null

clean:
	-rm *.fasta *.sto *.clstr primer_summary.txt *.stderr basic_hmmgs.txt gene_starts.txt*
